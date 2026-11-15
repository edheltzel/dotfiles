package cli

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	tea "charm.land/bubbletea/v2"
	"charm.land/fang/v2"
	"github.com/spf13/cobra"

	"github.com/edheltzel/aup/internal/config"
	"github.com/edheltzel/aup/internal/plain"
	"github.com/edheltzel/aup/internal/runner"
	"github.com/edheltzel/aup/internal/tui"
)

var (
	isTTY = func(v any) bool {
		f, ok := v.(*os.File)
		if !ok {
			return false
		}
		fi, err := f.Stat()
		return err == nil && fi.Mode()&os.ModeCharDevice != 0
	}
	knownDirs = runner.KnownDirs
)

type options struct {
	config, only    string
	dry, plain, tui bool
}

type usageError struct{ error }

func command(stdin io.Reader, stdout, stderr io.Writer, code *int) *cobra.Command {
	var o options
	cmd := &cobra.Command{
		Use:           "aup",
		Short:         "Update every installed agent harness in one run",
		Long:          "aup runs the update command of every step in its config, in order. Steps whose commands are not installed are skipped, a failed step never stops the next one, and the run is logged to ~/.local/state/aup/last.log.",
		Example:       "# update everything, live TUI on a terminal\naup\n\n# plain output (automatic off a terminal or when CI is set)\naup --plain\n\n# run one step\naup --only codex\n\n# show what would run\naup --dry-run",
		Args:          cobra.NoArgs,
		SilenceErrors: true,
		SilenceUsage:  true,
		RunE: func(cmd *cobra.Command, _ []string) error {
			*code = execute(cmd.Context(), o, stdin, stdout, stderr)
			return nil
		},
	}
	cmd.SetIn(stdin)
	cmd.SetOut(stdout)
	cmd.SetErr(stderr)
	cmd.SetFlagErrorFunc(func(_ *cobra.Command, err error) error { return usageError{err} })
	f := cmd.Flags()
	f.StringVarP(&o.config, "config", "c", "", "config file (default $AUP_CONFIG, then $XDG_CONFIG_HOME/aup/config.toml)")
	f.StringVar(&o.config, "manifest", "", "alias of --config")
	_ = f.MarkHidden("manifest")
	f.BoolVarP(&o.dry, "dry-run", "n", false, "print what would run, run nothing")
	f.StringVarP(&o.only, "only", "o", "", "run only the step with this label (case-insensitive)")
	f.BoolVar(&o.plain, "plain", false, "plain line output, no TUI")
	f.BoolVar(&o.plain, "no-tui", false, "alias of --plain")
	_ = f.MarkHidden("no-tui")
	f.BoolVar(&o.tui, "tui", false, "use the TUI even for --dry-run")
	return cmd
}

func Run(ctx context.Context, args []string, stdin io.Reader, stdout, stderr io.Writer) int {
	code := 0
	cmd := command(stdin, stdout, stderr, &code)
	cmd.SetArgs(args)
	if err := cmd.ExecuteContext(ctx); err != nil {
		fmt.Fprintln(stderr, "aup:", err)
		return 2
	}
	return code
}

func Main(version string) int {
	code := 0
	cmd := command(os.Stdin, os.Stdout, os.Stderr, &code)
	if err := fang.Execute(context.Background(), cmd, fang.WithVersion(version)); err != nil {
		var ue usageError
		if errors.As(err, &ue) {
			return 2
		}
		return 1
	}
	return code
}

func useTUI(o options, stdin io.Reader, stdout io.Writer) bool {
	if o.plain || (o.dry && !o.tui) {
		return false
	}
	if os.Getenv("CI") != "" || os.Getenv("TERM") == "dumb" {
		return false
	}
	return isTTY(stdout) && isTTY(stdin)
}

func execute(ctx context.Context, o options, stdin io.Reader, stdout, stderr io.Writer) int {
	home, err := os.UserHomeDir()
	if err != nil {
		fmt.Fprintln(stderr, "aup:", err)
		return 1
	}
	runner.ExtendPath(knownDirs(home))
	path := config.Path(o.config, home)
	steps, bad, err := config.Load(path)
	if err != nil {
		fmt.Fprintf(stderr, "aup: bad config %s: %v\n", path, err)
		return 1
	}
	if o.only != "" && !runner.Has(steps, o.only) {
		fmt.Fprintf(stderr, "aup: no step named %q\n", o.only)
		return 1
	}
	plan := runner.NewPlan(steps, o.only)
	color := os.Getenv("NO_COLOR") == "" && isTTY(stdout)
	var logf *os.File
	logPath := filepath.Join(home, ".local/state/aup/last.log")
	if !o.dry {
		if logf = openLog(logPath, stderr); logf != nil {
			defer logf.Close()
		} else {
			logPath = ""
		}
	}
	if useTUI(o, stdin, stdout) && len(plan.Tasks) > 0 {
		return runTUI(ctx, o, plan, bad, logf, logPath, stdin, stdout, stderr, color)
	}
	return runPlain(ctx, o, plan, bad, logf, stdin, stdout, stderr, color)
}

func openLog(path string, stderr io.Writer) *os.File {
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err == nil {
		if f, err := os.Create(path); err == nil {
			return f
		}
	}
	fmt.Fprintln(stderr, "aup: cannot write log, continuing without it")
	return nil
}

func runPlain(ctx context.Context, o options, plan runner.Plan, bad []config.RowError, logf *os.File, stdin io.Reader, stdout, stderr io.Writer, color bool) int {
	p := &plain.Printer{Out: stdout, ErrOut: stderr, Stdin: stdin, Direct: isTTY(stdout), Color: color}
	if logf != nil {
		strip := plain.Stripper{W: logf}
		p.Out, p.ErrOut, p.Log = io.MultiWriter(stdout, strip), io.MultiWriter(stderr, strip), logf
	}
	p.ChildOut, p.ChildErr = p.Out, p.ErrOut
	if p.Direct {
		p.ChildOut, p.ChildErr = stdout, stderr
	}
	p.Begin(plan, bad)
	r := &runner.Runner{DryRun: o.dry}
	s := r.Run(ctx, plan, p)
	failed := s.Failed + len(bad)
	p.Finish(plan, s, failed, o.dry)
	return exitCode(failed)
}

func runTUI(ctx context.Context, o options, plan runner.Plan, bad []config.RowError, logf *os.File, logPath string, stdin io.Reader, stdout, stderr io.Writer, color bool) int {
	var logOut io.Writer = io.Discard
	if logf != nil {
		logOut = plain.Stripper{W: logf}
	}
	logger := &plain.Printer{Out: logOut, ErrOut: logOut, ChildOut: logOut, ChildErr: logOut}
	logger.Begin(plan, bad)
	ctx, abort := context.WithCancel(ctx)
	defer abort()
	size := &tui.Size{}
	bridge := &tui.Bridge{Log: logger, LogOut: logOut, Size: size}
	model := tui.New(plan, tui.Options{CancelStep: bridge.CancelStep, Abort: abort, LogPath: tilde(logPath), Size: size})
	prog := tea.NewProgram(model, tea.WithContext(ctx), tea.WithInput(stdin), tea.WithOutput(stdout))
	bridge.Program = prog
	r := &runner.Runner{DryRun: o.dry}
	var s runner.Summary
	finished := make(chan struct{})
	go func() {
		defer close(finished)
		s = r.Run(ctx, plan, bridge)
		prog.Send(tui.FinishedMsg{})
	}()
	_, err := prog.Run()
	abort()
	<-finished
	if err != nil && !errors.Is(err, tea.ErrProgramKilled) && !errors.Is(err, context.Canceled) {
		fmt.Fprintln(stderr, "aup:", err)
	}
	failed := s.Failed + len(bad)
	logger.Finish(plan, s, failed, o.dry)
	final := &plain.Printer{Out: stdout, ErrOut: stderr, Color: color}
	final.Bad(bad)
	final.Finish(plan, s, failed, o.dry)
	if logPath != "" {
		fmt.Fprintln(stdout, final.Paint("90", "log: "+logPath))
	}
	return exitCode(failed)
}

func tilde(path string) string {
	if home, err := os.UserHomeDir(); err == nil && strings.HasPrefix(path, home+string(os.PathSeparator)) {
		return "~" + path[len(home):]
	}
	return path
}

func exitCode(failed int) int {
	if failed > 0 {
		return 1
	}
	return 0
}
