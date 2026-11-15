package plain

import (
	"fmt"
	"io"
	"os/exec"
	"regexp"
	"strconv"
	"strings"

	"github.com/edheltzel/aup/internal/config"
	"github.com/edheltzel/aup/internal/runner"
)

var ansiRe = regexp.MustCompile(`\x1b\[[0-9;?]*[ -/]*[@-~]|\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)`)

type Stripper struct{ W io.Writer }

func (s Stripper) Write(p []byte) (int, error) {
	if _, err := s.W.Write(ansiRe.ReplaceAll(p, nil)); err != nil {
		return 0, err
	}
	return len(p), nil
}

var rule = strings.Repeat("-", 45)

type Printer struct {
	Out, ErrOut        io.Writer
	ChildOut, ChildErr io.Writer
	Stdin              io.Reader
	Log                io.Writer
	Direct, Color      bool
}

func (p *Printer) Paint(code, s string) string {
	if !p.Color || code == "" {
		return s
	}
	return "\x1b[" + code + "m" + s + "\x1b[0m"
}

func RGB(hex string) string {
	hex = strings.TrimPrefix(strings.TrimSpace(hex), "#")
	n, err := strconv.ParseUint(hex, 16, 32)
	if err != nil || len(hex) != 6 {
		return ""
	}
	return fmt.Sprintf("38;2;%d;%d;%d", n>>16, n>>8&0xff, n&0xff)
}

func (p *Printer) Bad(bad []config.RowError) {
	for _, e := range bad {
		fmt.Fprint(p.ErrOut, p.Paint("31", "aup: "+e.Error()+"\n"))
	}
}

func (p *Printer) Begin(plan runner.Plan, bad []config.RowError) {
	p.Bad(bad)
	if have := plan.Installed(); len(have) > 0 {
		fmt.Fprintf(p.Out, "Installed: %s\n", strings.Join(have, ", "))
	}
	if missing := plan.Skipped(); len(missing) > 0 {
		fmt.Fprint(p.Out, p.Paint("90", "Not installed (skipped): "+strings.Join(missing, ", ")+"\n"))
	}
}

func (p *Printer) Started(_ int, t runner.Task) {
	fmt.Fprintln(p.Out)
	if len(t.Dups) > 0 {
		fmt.Fprint(p.Out, p.Paint("33", fmt.Sprintf("warning: %s is installed more than once: %s\n", t.Binary, strings.Join(t.Dups, ", "))))
	}
}

func (p *Printer) Command(_ int, t runner.Task, cmd *exec.Cmd) runner.Exec {
	fmt.Fprint(p.Out, p.Paint("1;"+RGB(t.Color), rule+"\n"+t.Label+" Update in Progress\n"+rule+"\n"))
	fmt.Fprintln(p.Out)
	cmd.Stdin, cmd.Stdout, cmd.Stderr = p.Stdin, p.ChildOut, p.ChildErr
	return runner.Direct
}

func (p *Printer) Done(_ int, t runner.Task, r runner.Result) {
	if r.Dry {
		fmt.Fprintf(p.Out, "%s would run: %s %s\n", t.Label, t.Path, strings.Join(t.Args, " "))
		return
	}
	if r.Err != nil {
		fmt.Fprintln(p.ErrOut, "aup:", r.Err)
	}
	if p.Direct && p.Log != nil {
		fmt.Fprintf(p.Log, "%s exit %d\n", t.Label, r.Code)
	}
	fmt.Fprintln(p.Out)
	if !r.OK() {
		fmt.Fprint(p.Out, p.Paint("31", r.Change(t.Label)+"\n"))
		return
	}
	msg := t.Label + " updated."
	if r.After != "" {
		msg = fmt.Sprintf("%s updated to v%s.", t.Label, r.After)
	}
	fmt.Fprint(p.Out, p.Paint(RGB(t.Color), msg+"\n"))
}

func (p *Printer) Finish(plan runner.Plan, s runner.Summary, failed int, dry bool) {
	var report []string
	if !dry {
		for i, t := range plan.Tasks {
			r := s.Results[i]
			code := RGB(t.Color)
			if !r.OK() {
				code = "31"
			}
			report = append(report, p.Paint(code, r.Change(t.Label)))
		}
	}
	missing := plan.Skipped()
	if len(report) > 0 || len(missing) > 0 {
		fmt.Fprint(p.Out, "\n"+rule+"\nUpdate report\n"+rule+"\n")
		for _, line := range report {
			fmt.Fprintln(p.Out, line)
		}
		for _, label := range missing {
			fmt.Fprint(p.Out, p.Paint("90", label+" skipped (not installed).\n"))
		}
	}
	verb := "updated"
	if dry {
		verb = "would run"
	}
	summary := fmt.Sprintf("%d %s, %d failed, %d skipped.\n", s.Done, verb, failed, s.Skipped)
	fmt.Fprintln(p.Out)
	if failed > 0 {
		fmt.Fprint(p.Out, p.Paint("31", summary))
		return
	}
	fmt.Fprint(p.Out, summary)
}
