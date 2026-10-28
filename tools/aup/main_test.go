package main

import (
	"bytes"
	"io"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/creack/pty"
)

type env struct {
	home, bin string
}

func setup(t *testing.T) env {
	t.Helper()
	e := env{home: t.TempDir(), bin: t.TempDir()}
	t.Setenv("HOME", e.home)
	t.Setenv("PATH", e.bin+":/bin:/usr/bin")
	t.Setenv("NO_COLOR", "")
	oldDirs, oldTTY := extraDirs, isTTY
	extraDirs = func(string) []string { return nil }
	isTTY = func(io.Writer) bool { return false }
	t.Cleanup(func() { extraDirs, isTTY = oldDirs, oldTTY })
	return e
}

func fake(t *testing.T, dir, name, script string) {
	t.Helper()
	if err := os.WriteFile(filepath.Join(dir, name), []byte("#!/bin/sh\n"+script+"\n"), 0o755); err != nil {
		t.Fatal(err)
	}
}

func manifest(t *testing.T, body string) string {
	t.Helper()
	p := filepath.Join(t.TempDir(), "harnesses.toml")
	if err := os.WriteFile(p, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	return p
}

func entry(label, binary, args string) string {
	return "[[harness]]\nlabel = \"" + label + "\"\ncolor = \"B392D7\"\nbinary = \"" + binary + "\"\nversion = \"" + binary + "\"\nargs = \"" + args + "\"\n"
}

func aup(t *testing.T, args ...string) (string, int) {
	t.Helper()
	var out, errOut bytes.Buffer
	code := run(args, &out, &errOut)
	return out.String() + errOut.String(), code
}

func TestSkipsMissingBinary(t *testing.T) {
	setup(t)
	out, code := aup(t, "--manifest", manifest(t, entry("Ghost", "aup-test-not-installed", "update")))
	if code != 0 || !strings.Contains(out, "Ghost skipped (not installed).") {
		t.Fatalf("code=%d out=%q", code, out)
	}
}

func TestFailureDoesNotStopLaterSteps(t *testing.T) {
	e := setup(t)
	marker := filepath.Join(e.home, "ran")
	fake(t, e.bin, "aup-bad", "exit 3")
	fake(t, e.bin, "aup-good", "echo 'aup-good 1.2.3'; touch "+marker)
	out, code := aup(t, "--manifest", manifest(t, entry("Bad", "aup-bad", "x")+entry("Good", "aup-good", "x")))
	if _, err := os.Stat(marker); err != nil {
		t.Fatalf("later step did not run: %q", out)
	}
	if code != 1 || !strings.Contains(out, "Bad update failed (exit 3).") || !strings.Contains(out, "Good updated to v1.2.3.") {
		t.Fatalf("code=%d out=%q", code, out)
	}
}

func TestDryRunRunsNothing(t *testing.T) {
	e := setup(t)
	marker := filepath.Join(e.home, "ran")
	fake(t, e.bin, "aup-good", "touch "+marker)
	out, code := aup(t, "--dry-run", "--manifest", manifest(t, entry("Good", "aup-good", "update --now")))
	if _, err := os.Stat(marker); err == nil {
		t.Fatal("dry run executed the binary")
	}
	if _, err := os.Stat(filepath.Join(e.home, ".local/state/aup/last.log")); err == nil {
		t.Fatal("dry run wrote the log")
	}
	if code != 0 || !strings.Contains(out, "Good would run: ") || !strings.Contains(out, "update --now") {
		t.Fatalf("code=%d out=%q", code, out)
	}
}

func TestOnlyFiltersByNameIgnoringCase(t *testing.T) {
	e := setup(t)
	fake(t, e.bin, "aup-a", "echo ran-a")
	fake(t, e.bin, "aup-b", "echo ran-b")
	m := manifest(t, entry("Alpha", "aup-a", "x")+entry("Beta", "aup-b", "x"))
	out, code := aup(t, "--only", "bETa", "--manifest", m)
	if code != 0 || strings.Contains(out, "ran-a") || !strings.Contains(out, "ran-b") {
		t.Fatalf("code=%d out=%q", code, out)
	}
	if _, code := aup(t, "--only", "nope", "--manifest", m); code != 1 {
		t.Fatalf("unknown --only exit = %d, want 1", code)
	}
}

func TestWarnsOnDuplicateInstalls(t *testing.T) {
	e := setup(t)
	other := t.TempDir()
	fake(t, e.bin, "aup-dup", "true")
	fake(t, other, "aup-dup", "true")
	t.Setenv("PATH", e.bin+":"+other+":/bin:/usr/bin")
	out, _ := aup(t, "--dry-run", "--manifest", manifest(t, entry("Dup", "aup-dup", "x")))
	if !strings.Contains(out, "warning: aup-dup is installed more than once") || !strings.Contains(out, e.bin) || !strings.Contains(out, other) {
		t.Fatalf("out=%q", out)
	}
}

func TestSymlinkToSameBinaryIsNotDuplicate(t *testing.T) {
	e := setup(t)
	other := t.TempDir()
	fake(t, e.bin, "aup-one", "true")
	if err := os.Symlink(filepath.Join(e.bin, "aup-one"), filepath.Join(other, "aup-one")); err != nil {
		t.Fatal(err)
	}
	t.Setenv("PATH", e.bin+":"+other+":/bin:/usr/bin")
	out, _ := aup(t, "--dry-run", "--manifest", manifest(t, entry("One", "aup-one", "x")))
	if strings.Contains(out, "warning") {
		t.Fatalf("out=%q", out)
	}
}

func TestLogFileTeesOutput(t *testing.T) {
	e := setup(t)
	fake(t, e.bin, "aup-good", "echo hello-from-child; echo oops >&2")
	out, _ := aup(t, "--manifest", manifest(t, entry("Good", "aup-good", "x")))
	log, err := os.ReadFile(filepath.Join(e.home, ".local/state/aup/last.log"))
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"hello-from-child", "oops", "Good updated."} {
		if !strings.Contains(string(log), want) || !strings.Contains(out, want) {
			t.Fatalf("%q missing\nlog=%q\nout=%q", want, log, out)
		}
	}
}

func TestChildKeepsTerminalWhenStdoutIsTTY(t *testing.T) {
	real := isTTY
	e := setup(t)
	isTTY = real
	fake(t, e.bin, "aup-tty", "echo child-output; test -t 1 && test -t 2")
	ptmx, tty, err := pty.Open()
	if err != nil {
		t.Fatal(err)
	}
	defer ptmx.Close()
	defer tty.Close()
	go io.Copy(io.Discard, ptmx)
	if code := run([]string{"--manifest", manifest(t, entry("Tty", "aup-tty", "x"))}, tty, tty); code != 0 {
		t.Fatalf("child did not get the terminal, exit %d", code)
	}
	log, err := os.ReadFile(filepath.Join(e.home, ".local/state/aup/last.log"))
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(log), "child-output") || !strings.Contains(string(log), "Tty exit 0") {
		t.Fatalf("log=%q", log)
	}
}

func TestNoColorGivesPlainText(t *testing.T) {
	e := setup(t)
	isTTY = func(io.Writer) bool { return true }
	fake(t, e.bin, "aup-good", "true")
	m := manifest(t, entry("Good", "aup-good", "x"))
	if out, _ := aup(t, "--manifest", m); !strings.Contains(out, "\x1b[") {
		t.Fatalf("expected colour on a tty: %q", out)
	}
	t.Setenv("NO_COLOR", "1")
	if out, _ := aup(t, "--manifest", m); strings.Contains(out, "\x1b") {
		t.Fatalf("NO_COLOR ignored: %q", out)
	}
}

func TestKnownDirsAreOnPath(t *testing.T) {
	e := setup(t)
	extra := t.TempDir()
	extraDirs = func(string) []string { return []string{extra} }
	fake(t, extra, "aup-extra", "echo ok")
	out, code := aup(t, "--manifest", manifest(t, entry("Extra", "aup-extra", "x")))
	if code != 0 || !strings.Contains(out, "Extra updated.") {
		t.Fatalf("code=%d out=%q home=%s", code, out, e.home)
	}
}

func TestKnownDirsAppendOrder(t *testing.T) {
	real := extraDirs
	setup(t)
	want := "/opt/homebrew/bin,/opt/homebrew/sbin,/h/.local/bin,/h/.bun/bin,/h/.empryo/bin,/h/Library/pnpm,/usr/local/bin"
	if got := strings.Join(real("/h"), ","); got != want {
		t.Fatalf("known dirs %s, want %s", got, want)
	}
}

func TestInheritedPathWinsOverKnownDirs(t *testing.T) {
	e := setup(t)
	first, second := t.TempDir(), t.TempDir()
	extraDirs = func(string) []string { return []string{first, second} }
	fake(t, e.bin, "aup-inherited", "echo from-path")
	fake(t, first, "aup-inherited", "echo from-known")
	fake(t, first, "aup-both", "echo from-first")
	fake(t, second, "aup-both", "echo from-second")
	out, _ := aup(t, "--manifest", manifest(t, entry("Inh", "aup-inherited", "x")+entry("Both", "aup-both", "x")))
	if !strings.Contains(out, "from-path") || strings.Contains(out, "from-known") || !strings.Contains(out, "from-first") || strings.Contains(out, "from-second") {
		t.Fatalf("out=%q", out)
	}
}

func TestInheritedPathOrderIsKept(t *testing.T) {
	setup(t)
	t.Setenv("PATH", "/a:/b")
	extraDirs = func(string) []string { return []string{"/b", "/c"} }
	aup(t, "--dry-run", "--manifest", manifest(t, ""))
	if got := os.Getenv("PATH"); got != "/a:/b:/c" {
		t.Fatalf("PATH=%s, want /a:/b:/c", got)
	}
}

func TestBadRowFailsRunButOthersContinue(t *testing.T) {
	e := setup(t)
	fake(t, e.bin, "aup-good", "echo ran")
	m := manifest(t, "[[harness]]\nlabel = \"NoColor\"\nbinary = \"x\"\n"+entry("Good", "aup-good", "x"))
	out, code := aup(t, "--manifest", m)
	if code != 1 || !strings.Contains(out, "harness 1: missing color") || !strings.Contains(out, "Good updated.") {
		t.Fatalf("code=%d out=%q", code, out)
	}
}

func TestShippedManifestParses(t *testing.T) {
	hs, bad, err := load("../../config/.config/aup/harnesses.toml")
	if err != nil || len(bad) != 0 || len(hs) == 0 {
		t.Fatalf("hs=%d bad=%v err=%v", len(hs), bad, err)
	}
	for _, h := range hs {
		if h.label == "Plannotator" && len(h.args) != 4 {
			t.Fatalf("list args not kept intact: %v", h.args)
		}
	}
}
