package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"strconv"
	"strings"

	"github.com/BurntSushi/toml"
)

var (
	versionRe = regexp.MustCompile(`\d+\.\d+\.\d+(?:[-+][^ ]+)?`)
	ansiRe    = regexp.MustCompile(`\x1b\[[0-9;]*m`)

	isTTY = func(w io.Writer) bool {
		f, ok := w.(*os.File)
		if !ok {
			return false
		}
		fi, err := f.Stat()
		return err == nil && fi.Mode()&os.ModeCharDevice != 0
	}

	extraDirs = func(home string) []string {
		return []string{
			"/opt/homebrew/bin",
			"/opt/homebrew/sbin",
			filepath.Join(home, ".local/bin"),
			filepath.Join(home, ".bun/bin"),
			filepath.Join(home, ".empryo/bin"),
			filepath.Join(home, "Library/pnpm"),
			"/usr/local/bin",
		}
	}
)

type harness struct {
	label, color, binary, version string
	args                          []string
}

type app struct {
	out, errOut   io.Writer
	childOut      io.Writer
	childErr      io.Writer
	log           io.Writer
	direct, color bool
}

type ansiStripper struct{ w io.Writer }

func (s ansiStripper) Write(p []byte) (int, error) {
	if _, err := s.w.Write(ansiRe.ReplaceAll(p, nil)); err != nil {
		return 0, err
	}
	return len(p), nil
}

func main() {
	os.Exit(run(os.Args[1:], os.Stdout, os.Stderr))
}

func run(args []string, stdout, stderr io.Writer) int {
	home, err := os.UserHomeDir()
	if err != nil {
		fmt.Fprintln(stderr, "aup:", err)
		return 1
	}
	fs := flag.NewFlagSet("aup", flag.ContinueOnError)
	fs.SetOutput(stderr)
	manifest := fs.String("manifest", filepath.Join(home, ".config/aup/harnesses.toml"), "harness manifest `path`")
	dry := fs.Bool("dry-run", false, "print what would run, run nothing")
	only := fs.String("only", "", "run only the entry called `name` (case-insensitive)")
	if err := fs.Parse(args); err != nil {
		return 2
	}

	a := &app{out: stdout, errOut: stderr, log: io.Discard, direct: isTTY(stdout), color: os.Getenv("NO_COLOR") == "" && isTTY(stdout)}
	setPath(home)

	harnesses, bad, err := load(*manifest)
	if err != nil {
		fmt.Fprintf(stderr, "aup: bad manifest %s: %v\n", *manifest, err)
		return 1
	}
	if *only != "" && !slices.ContainsFunc(harnesses, func(h harness) bool { return strings.EqualFold(h.label, *only) }) {
		fmt.Fprintf(stderr, "aup: no entry named %q\n", *only)
		return 1
	}

	if !*dry {
		if logf := openLog(home, stderr); logf != nil {
			defer logf.Close()
			plain := ansiStripper{logf}
			a.out = io.MultiWriter(stdout, plain)
			a.errOut = io.MultiWriter(stderr, plain)
			a.log = logf
		}
	}
	a.childOut, a.childErr = a.out, a.errOut
	if a.direct {
		a.childOut, a.childErr = stdout, stderr
	}

	failed := len(bad)
	for _, msg := range bad {
		fmt.Fprint(a.errOut, a.paint("31", "aup: harness "+msg+"\n"))
	}

	var done, skipped int
	warned := map[string]bool{}
	for _, h := range harnesses {
		if *only != "" && !strings.EqualFold(h.label, *only) {
			continue
		}
		fmt.Fprintln(a.out)
		path, err := exec.LookPath(h.binary)
		if err != nil {
			fmt.Fprint(a.out, a.paint("90", h.label+" skipped (not installed).\n"))
			skipped++
			continue
		}
		if !warned[h.binary] {
			warned[h.binary] = true
			if dups := realPaths(h.binary); len(dups) > 1 {
				fmt.Fprint(a.out, a.paint("33", fmt.Sprintf("warning: %s is installed more than once: %s\n", h.binary, strings.Join(dups, ", "))))
			}
		}
		if *dry {
			fmt.Fprintf(a.out, "%s would run: %s %s\n", h.label, path, strings.Join(h.args, " "))
			done++
			continue
		}
		if code := a.update(h, path); code != 0 {
			failed++
		} else {
			done++
		}
	}

	verb := "updated"
	if *dry {
		verb = "would run"
	}
	summary := fmt.Sprintf("%d %s, %d failed, %d skipped.\n", done, verb, failed, skipped)
	fmt.Fprintln(a.out)
	if failed > 0 {
		fmt.Fprint(a.out, a.paint("31", summary))
		return 1
	}
	fmt.Fprint(a.out, summary)
	return 0
}

func (a *app) update(h harness, path string) int {
	fmt.Fprint(a.out, a.paint("1;"+rgb(h.color), strings.Repeat("-", 45)+"\n"+h.label+" Update in Progress\n"+strings.Repeat("-", 45)+"\n"))
	fmt.Fprintln(a.out)

	cmd := exec.Command(path, h.args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = a.childOut
	cmd.Stderr = a.childErr
	code := 0
	if err := cmd.Run(); err != nil {
		var ee *exec.ExitError
		if errors.As(err, &ee) {
			code = ee.ExitCode()
		} else {
			fmt.Fprintln(a.errOut, "aup:", err)
			code = 127
		}
	}

	if a.direct {
		fmt.Fprintf(a.log, "%s exit %d\n", h.label, code)
	}
	fmt.Fprintln(a.out)
	if code != 0 {
		fmt.Fprint(a.out, a.paint("31", fmt.Sprintf("%s update failed (exit %d).\n", h.label, code)))
		return code
	}
	msg := h.label + " updated.\n"
	if v := probeVersion(h.version); v != "" {
		msg = fmt.Sprintf("%s updated to v%s.\n", h.label, v)
	}
	fmt.Fprint(a.out, a.paint(rgb(h.color), msg))
	return 0
}

func probeVersion(bin string) string {
	if bin == "-" {
		return ""
	}
	path, err := exec.LookPath(bin)
	if err != nil {
		return ""
	}
	out, _ := exec.Command(path, "--version").CombinedOutput()
	return versionRe.FindString(string(out))
}

func (a *app) paint(code, s string) string {
	if !a.color || code == "" {
		return s
	}
	return "\x1b[" + code + "m" + s + "\x1b[0m"
}

func rgb(hex string) string {
	hex = strings.TrimPrefix(strings.TrimSpace(hex), "#")
	n, err := strconv.ParseUint(hex, 16, 32)
	if err != nil || len(hex) != 6 {
		return ""
	}
	return fmt.Sprintf("38;2;%d;%d;%d", n>>16, n>>8&0xff, n&0xff)
}

func openLog(home string, stderr io.Writer) *os.File {
	dir := filepath.Join(home, ".local/state/aup")
	if err := os.MkdirAll(dir, 0o755); err == nil {
		if f, err := os.Create(filepath.Join(dir, "last.log")); err == nil {
			return f
		}
	}
	fmt.Fprintln(stderr, "aup: cannot write log, continuing without it")
	return nil
}

func setPath(home string) {
	inherited := filepath.SplitList(os.Getenv("PATH"))
	have := map[string]bool{}
	for _, d := range inherited {
		have[d] = true
	}
	for _, d := range extraDirs(home) {
		if !have[d] {
			have[d] = true
			inherited = append(inherited, d)
		}
	}
	os.Setenv("PATH", strings.Join(inherited, string(os.PathListSeparator)))
}

func realPaths(bin string) []string {
	var found []string
	seen := map[string]bool{}
	for _, d := range filepath.SplitList(os.Getenv("PATH")) {
		if d == "" {
			continue
		}
		p := filepath.Join(d, bin)
		fi, err := os.Stat(p)
		if err != nil || fi.IsDir() || fi.Mode()&0o111 == 0 {
			continue
		}
		if r, err := filepath.EvalSymlinks(p); err == nil && !seen[r] {
			seen[r] = true
			found = append(found, r)
		}
	}
	return found
}

func load(path string) (harnesses []harness, bad []string, err error) {
	var doc map[string]any
	if _, err := toml.DecodeFile(path, &doc); err != nil {
		return nil, nil, err
	}
	rows, ok := doc["harness"].([]map[string]any)
	if !ok && doc["harness"] != nil {
		return nil, nil, errors.New("harness must be an array of tables")
	}
	for i, row := range rows {
		h := harness{
			label:   field(row["label"]),
			color:   field(row["color"]),
			binary:  field(row["binary"]),
			version: field(row["version"]),
		}
		var missing []string
		for _, c := range [][2]string{{"label", h.label}, {"color", h.color}, {"binary", h.binary}} {
			if c[1] == "" {
				missing = append(missing, c[0])
			}
		}
		if len(missing) > 0 {
			bad = append(bad, fmt.Sprintf("%d: missing %s", i+1, strings.Join(missing, ", ")))
			continue
		}
		if h.version == "" {
			h.version = "-"
		}
		switch a := row["args"].(type) {
		case nil:
		case string:
			h.args = strings.Fields(a)
		case []any:
			for _, x := range a {
				h.args = append(h.args, fmt.Sprint(x))
			}
		default:
			bad = append(bad, fmt.Sprintf("%d: args must be a string or list", i+1))
			continue
		}
		harnesses = append(harnesses, h)
	}
	return harnesses, bad, nil
}

func field(v any) string {
	if v == nil {
		return ""
	}
	return strings.TrimSpace(fmt.Sprint(v))
}
