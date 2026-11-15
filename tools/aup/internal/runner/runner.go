package runner

import (
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/edheltzel/aup/internal/config"
)

var ErrCancelled = errors.New("cancelled")

var versionRe = regexp.MustCompile(`\d+\.\d+\.\d+(?:[-+][^ ]+)?`)

func KnownDirs(home string) []string {
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

func ExtendPath(extra []string) {
	inherited := filepath.SplitList(os.Getenv("PATH"))
	have := map[string]bool{}
	for _, d := range inherited {
		have[d] = true
	}
	for _, d := range extra {
		if !have[d] {
			have[d] = true
			inherited = append(inherited, d)
		}
	}
	os.Setenv("PATH", strings.Join(inherited, string(os.PathListSeparator)))
}

type Task struct {
	config.Step
	Path string
	Dups []string
}

type Plan struct {
	Tasks   []Task
	Missing []config.Step
}

func (p Plan) Installed() []string {
	labels := make([]string, len(p.Tasks))
	for i, t := range p.Tasks {
		labels[i] = t.Label
	}
	return labels
}

func (p Plan) Skipped() []string {
	labels := make([]string, len(p.Missing))
	for i, s := range p.Missing {
		labels[i] = s.Label
	}
	return labels
}

func Has(steps []config.Step, label string) bool {
	for _, s := range steps {
		if strings.EqualFold(s.Label, label) {
			return true
		}
	}
	return false
}

func NewPlan(steps []config.Step, only string) Plan {
	var p Plan
	warned := map[string]bool{}
	for _, s := range steps {
		if only != "" && !strings.EqualFold(s.Label, only) {
			continue
		}
		path, err := exec.LookPath(s.Binary)
		if _, ierr := exec.LookPath(s.Installed); err != nil || ierr != nil {
			p.Missing = append(p.Missing, s)
			continue
		}
		t := Task{Step: s, Path: path}
		if !warned[s.Binary] {
			warned[s.Binary] = true
			if dups := RealPaths(s.Binary); len(dups) > 1 {
				t.Dups = dups
			}
		}
		p.Tasks = append(p.Tasks, t)
	}
	return p
}

func RealPaths(bin string) []string {
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

func ProbeVersion(bin string) string {
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

type Result struct {
	Code          int
	Err           error
	Before, After string
	Dry           bool
	Cancelled     bool
}

func (r Result) OK() bool { return r.Code == 0 && r.Err == nil && !r.Cancelled }

func (r Result) Change(label string) string {
	switch {
	case !r.OK():
		return fmt.Sprintf("%s update failed (exit %d).", label, r.Code)
	case r.After == "":
		return label + " ran (no version to compare)."
	case r.Before == r.After:
		return fmt.Sprintf("%s already at v%s.", label, r.After)
	case r.Before == "":
		return fmt.Sprintf("%s updated to v%s.", label, r.After)
	default:
		return fmt.Sprintf("%s updated from v%s to v%s.", label, r.Before, r.After)
	}
}

type Exec func(ctx context.Context, cmd *exec.Cmd, t Task) error

type Sink interface {
	Started(i int, t Task)
	Command(i int, t Task, cmd *exec.Cmd) Exec
	Done(i int, t Task, r Result)
}

type Summary struct {
	Done, Failed, Skipped int
	Results               []Result
}

type Runner struct {
	DryRun bool
}

func Direct(ctx context.Context, cmd *exec.Cmd, _ Task) error {
	if err := cmd.Start(); err != nil {
		return err
	}
	return cmd.Wait()
}

func (r *Runner) Run(ctx context.Context, plan Plan, sink Sink) Summary {
	s := Summary{Skipped: len(plan.Missing), Results: make([]Result, len(plan.Tasks))}
	for i, t := range plan.Tasks {
		if ctx.Err() != nil {
			res := Result{Code: 130, Cancelled: true}
			s.Results[i] = res
			s.Failed++
			sink.Done(i, t, res)
			continue
		}
		sink.Started(i, t)
		res := r.step(ctx, i, t, sink)
		s.Results[i] = res
		if res.OK() {
			s.Done++
		} else {
			s.Failed++
		}
		sink.Done(i, t, res)
	}
	return s
}

func (r *Runner) step(ctx context.Context, i int, t Task, sink Sink) Result {
	if r.DryRun {
		return Result{Dry: true}
	}
	res := Result{Before: ProbeVersion(t.Version)}
	stepCtx, cancel := context.WithCancel(ctx)
	if t.Timeout > 0 {
		stepCtx, cancel = context.WithTimeout(ctx, t.Timeout)
	}
	defer cancel()
	cmd := exec.CommandContext(stepCtx, t.Path, t.Args...)
	cmd.WaitDelay = time.Second
	if len(t.Env) > 0 {
		cmd.Env = os.Environ()
		for k, v := range t.Env {
			cmd.Env = append(cmd.Env, k+"="+v)
		}
	}
	run := sink.Command(i, t, cmd)
	if run == nil {
		run = Direct
	}
	err := run(stepCtx, cmd, t)
	var ee *exec.ExitError
	switch {
	case err == nil:
	case errors.Is(err, ErrCancelled):
		res.Code, res.Cancelled = 130, true
	case stepCtx.Err() != nil:
		res.Code, res.Cancelled = 130, true
		if errors.Is(stepCtx.Err(), context.DeadlineExceeded) {
			res.Code, res.Cancelled, res.Err = 124, false, fmt.Errorf("timed out after %s", t.Timeout)
		}
	case errors.As(err, &ee):
		res.Code = ee.ExitCode()
	default:
		res.Code, res.Err = 127, err
	}
	if res.OK() {
		res.After = ProbeVersion(t.Version)
	}
	return res
}
