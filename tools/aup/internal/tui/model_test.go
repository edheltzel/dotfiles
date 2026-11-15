package tui

import (
	"bytes"
	"context"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	tea "charm.land/bubbletea/v2"
	"github.com/charmbracelet/x/ansi"
	"github.com/charmbracelet/x/exp/golden"
	"github.com/charmbracelet/x/exp/teatest/v2"

	"github.com/edheltzel/aup/internal/config"
	"github.com/edheltzel/aup/internal/plain"
	"github.com/edheltzel/aup/internal/runner"
)

func fixedPlan() runner.Plan {
	task := func(label, color string, dups ...string) runner.Task {
		return runner.Task{Step: config.Step{Label: label, Color: color, Binary: strings.ToLower(label), Version: "-"}, Path: "/bin/" + strings.ToLower(label), Dups: dups}
	}
	return runner.Plan{
		Tasks: []runner.Task{
			task("Opencode", "61747f"),
			task("Claude Code", "D97757"),
			task("Codex", "10A37F", "/a/codex", "/b/codex"),
			task("Amp", "F34E3F"),
		},
		Missing: []config.Step{{Label: "Grok", Color: "FFFFFF"}},
	}
}

func step(m *Model, msgs ...tea.Msg) {
	for _, msg := range msgs {
		m.Update(msg)
	}
}

func screenText(m *Model) []byte {
	lines := strings.Split(ansi.Strip(m.render()), "\n")
	for i, l := range lines {
		lines[i] = strings.TrimRight(l, " ")
	}
	return []byte(strings.Join(lines, "\n") + "\n")
}

func TestViewGolden(t *testing.T) {
	t0 := time.Date(2026, 11, 13, 9, 0, 0, 0, time.UTC)
	m := New(fixedPlan(), Options{Now: func() time.Time { return t0.Add(42 * time.Second) }, LogPath: "~/.local/state/aup/last.log"})
	m.start = t0
	step(m, tea.WindowSizeMsg{Width: 100, Height: 20},
		StartedMsg{I: 0},
		OutputMsg{I: 0, Data: []byte("Checking for updates...\nUpdated to 1.5.0\n")},
		DoneMsg{I: 0, Result: runner.Result{Before: "1.4.0", After: "1.5.0"}},
		StartedMsg{I: 1},
		OutputMsg{I: 1, Data: []byte("Downloading 2.3.1\r\x1b[32m 80%\x1b[0m")},
	)
	t.Run("running", func(t *testing.T) { golden.RequireEqual(t, screenText(m)) })
	step(m,
		DoneMsg{I: 1, Result: runner.Result{Code: 3}},
		StartedMsg{I: 2},
		DoneMsg{I: 2, Result: runner.Result{After: "0.9.0"}},
		StartedMsg{I: 3},
		DoneMsg{I: 3, Result: runner.Result{Code: 130, Cancelled: true}},
		FinishedMsg{},
	)
	t.Run("summary", func(t *testing.T) { golden.RequireEqual(t, screenText(m)) })
}

func TestSelectingAStepShowsItsOutput(t *testing.T) {
	m := New(fixedPlan(), Options{})
	step(m, tea.WindowSizeMsg{Width: 100, Height: 20},
		StartedMsg{I: 0}, OutputMsg{I: 0, Data: []byte("first-output\n")}, DoneMsg{I: 0},
		StartedMsg{I: 1}, OutputMsg{I: 1, Data: []byte("second-output\n")},
	)
	if v := ansi.Strip(m.render()); !strings.Contains(v, "second-output") {
		t.Fatalf("follow mode did not show the running step:\n%s", v)
	}
	m.Update(tea.KeyPressMsg{Code: 'k', Text: "k"})
	if v := ansi.Strip(m.render()); !strings.Contains(v, "first-output") || m.follow {
		t.Fatalf("k did not select the previous step:\n%s", v)
	}
	m.Update(tea.KeyPressMsg{Code: 'f', Text: "f"})
	if m.sel != 1 || !m.follow {
		t.Fatalf("f did not return to the running step: sel=%d", m.sel)
	}
	m.Update(tea.KeyPressMsg{Code: 'j', Text: "j"})
	m.Update(tea.KeyPressMsg{Code: 'j', Text: "j"})
	m.Update(tea.KeyPressMsg{Code: 'j', Text: "j"})
	if v := ansi.Strip(m.render()); !strings.Contains(v, "Not installed. Nothing to run.") {
		t.Fatalf("skipped step view:\n%s", v)
	}
}

func TestKeysCancelStepAndQuit(t *testing.T) {
	var cancelled, aborted int
	m := New(fixedPlan(), Options{CancelStep: func() { cancelled++ }, Abort: func() { aborted++ }})
	tm := teatest.NewTestModel(t, m, teatest.WithInitialTermSize(100, 24))
	tm.Send(StartedMsg{I: 0})
	teatest.WaitFor(t, tm.Output(), func(b []byte) bool { return bytes.Contains(b, []byte("Opencode")) })
	tm.Send(tea.KeyPressMsg{Code: 'c', Mod: tea.ModCtrl})
	tm.Send(tea.KeyPressMsg{Code: 'q', Text: "q"})
	tm.Send(DoneMsg{I: 0, Result: runner.Result{Code: 130, Cancelled: true}})
	tm.Send(FinishedMsg{})
	final := tm.FinalModel(t, teatest.WithFinalTimeout(3*time.Second)).(*Model)
	if cancelled != 1 || aborted != 1 || !final.done || final.rows[0].status != failed {
		t.Fatalf("cancelled=%d aborted=%d done=%v status=%v", cancelled, aborted, final.done, final.rows[0].status)
	}
}

func TestSummaryClosesOnEnter(t *testing.T) {
	m := New(fixedPlan(), Options{})
	tm := teatest.NewTestModel(t, m, teatest.WithInitialTermSize(100, 24))
	for i := range 4 {
		tm.Send(StartedMsg{I: i})
		tm.Send(DoneMsg{I: i})
	}
	tm.Send(FinishedMsg{})
	teatest.WaitFor(t, tm.Output(), func(b []byte) bool { return bytes.Contains(b, []byte("4 updated, 0 failed, 1 skipped.")) })
	tm.Send(tea.KeyPressMsg{Code: tea.KeyEnter})
	tm.WaitFinished(t, teatest.WithFinalTimeout(3*time.Second))
}

type recorder struct {
	mu   sync.Mutex
	msgs []tea.Msg
}

func (r *recorder) Send(msg tea.Msg) {
	r.mu.Lock()
	r.msgs = append(r.msgs, msg)
	r.mu.Unlock()
}

func (r *recorder) output(i int) string {
	r.mu.Lock()
	defer r.mu.Unlock()
	var b strings.Builder
	for _, m := range r.msgs {
		if o, ok := m.(OutputMsg); ok && o.I == i {
			b.Write(o.Data)
		}
	}
	return b.String()
}

func script(t *testing.T, body string) string {
	t.Helper()
	p := filepath.Join(t.TempDir(), "step")
	if err := os.WriteFile(p, []byte("#!/bin/sh\n"+body+"\n"), 0o755); err != nil {
		t.Fatal(err)
	}
	return p
}

func bridge(rec *recorder, log *bytes.Buffer) *Bridge {
	out := plain.Stripper{W: log}
	return &Bridge{Program: rec, Log: &plain.Printer{Out: out, ErrOut: out, ChildOut: out, ChildErr: out}, LogOut: out, Size: &Size{}}
}

func TestBridgeRunsStepOnPTYAndLogsPlainText(t *testing.T) {
	path := script(t, "test -t 1 && test -t 2 && printf '\\033[31mred-out\\033[0m\\n'")
	plan := runner.Plan{Tasks: []runner.Task{{Step: config.Step{Label: "Tty", Color: "B392D7", Version: "-"}, Path: path}}}
	rec, log := &recorder{}, &bytes.Buffer{}
	s := (&runner.Runner{}).Run(context.Background(), plan, bridge(rec, log))
	if s.Failed != 0 || !strings.Contains(rec.output(0), "\x1b[31mred-out") {
		t.Fatalf("summary=%+v output=%q", s, rec.output(0))
	}
	if l := log.String(); !strings.Contains(l, "red-out") || strings.Contains(l, "\x1b") || !strings.Contains(l, "Tty Update in Progress") {
		t.Fatalf("log=%q", l)
	}
}

func TestBridgeCancelStopsOnlyTheCurrentStep(t *testing.T) {
	slow := script(t, "echo started; exec sleep 30")
	fast := script(t, "echo second-ran")
	plan := runner.Plan{Tasks: []runner.Task{
		{Step: config.Step{Label: "Slow", Version: "-"}, Path: slow},
		{Step: config.Step{Label: "Fast", Version: "-"}, Path: fast},
	}}
	rec, log := &recorder{}, &bytes.Buffer{}
	b := bridge(rec, log)
	go func() {
		for !strings.Contains(rec.output(0), "started") {
			time.Sleep(10 * time.Millisecond)
		}
		b.CancelStep()
	}()
	start := time.Now()
	s := (&runner.Runner{}).Run(context.Background(), plan, b)
	if time.Since(start) > 10*time.Second || !s.Results[0].Cancelled || !s.Results[1].OK() || !strings.Contains(rec.output(1), "second-ran") {
		t.Fatalf("results=%+v", s.Results)
	}
}
