package main

import (
	"bytes"
	"errors"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/creack/pty"
)

func build(t *testing.T) string {
	t.Helper()
	bin := filepath.Join(t.TempDir(), "aup")
	if out, err := exec.Command("go", "build", "-o", bin, ".").CombinedOutput(); err != nil {
		t.Fatalf("build: %v\n%s", err, out)
	}
	return bin
}

type buffer struct {
	mu sync.Mutex
	b  bytes.Buffer
}

func (b *buffer) Write(p []byte) (int, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.b.Write(p)
}

func (b *buffer) String() string {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.b.String()
}

func TestTUIRunEndToEnd(t *testing.T) {
	bin := build(t)
	home, tools := t.TempDir(), t.TempDir()
	write := func(path, body string, mode os.FileMode) {
		if err := os.WriteFile(path, []byte(body), mode); err != nil {
			t.Fatal(err)
		}
	}
	write(filepath.Join(tools, "aup-good"), "#!/bin/sh\nif [ \"$1\" = --version ]; then echo 'good 2.0.0'; exit; fi\ntest -t 1 && echo good-on-a-tty\n", 0o755)
	write(filepath.Join(tools, "aup-bad"), "#!/bin/sh\necho bad-output; exit 5\n", 0o755)
	cfg := filepath.Join(home, "config.toml")
	write(cfg, "[[step]]\nlabel = \"Good\"\ncolor = \"5FD7A7\"\nbinary = \"aup-good\"\nversion = \"aup-good\"\nargs = \"update\"\n\n[[step]]\nlabel = \"Bad\"\ncolor = \"FF6B8B\"\nbinary = \"aup-bad\"\nargs = \"update\"\n\n[[step]]\nlabel = \"Ghost\"\ncolor = \"FFFFFF\"\nbinary = \"aup-not-installed\"\n", 0o644)

	cmd := exec.Command(bin, "--config", cfg)
	cmd.Env = append(os.Environ(), "HOME="+home, "PATH="+tools+":/bin:/usr/bin", "CI=", "TERM=xterm-256color", "NO_COLOR=")
	f, err := pty.StartWithSize(cmd, &pty.Winsize{Rows: 30, Cols: 100})
	if err != nil {
		t.Fatal(err)
	}
	defer f.Close()
	out := &buffer{}
	go io.Copy(out, f)
	wait := func(want string) {
		t.Helper()
		deadline := time.Now().Add(15 * time.Second)
		for !strings.Contains(out.String(), want) {
			if time.Now().After(deadline) {
				t.Fatalf("timed out waiting for %q\n%q", want, out.String())
			}
			time.Sleep(20 * time.Millisecond)
		}
	}
	wait("1 updated, 1 failed, 1 skipped.")
	if _, err := f.Write([]byte("\r")); err != nil {
		t.Fatal(err)
	}
	err = cmd.Wait()
	var ee *exec.ExitError
	if err == nil || !errors.As(err, &ee) || ee.ExitCode() != 1 {
		t.Fatalf("exit err=%v\n%q", err, out.String())
	}
	wait("Update report")
	for _, want := range []string{"Good already at v2.0.0.", "Bad update failed (exit 5).", "Ghost skipped (not installed)."} {
		wait(want)
	}
	log, err := os.ReadFile(filepath.Join(home, ".local/state/aup/last.log"))
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"good-on-a-tty", "bad-output", "Bad update failed (exit 5).", "1 updated, 1 failed, 1 skipped."} {
		if !strings.Contains(string(log), want) {
			t.Fatalf("%q missing from log %q", want, log)
		}
	}
	if strings.Contains(string(log), "\x1b") {
		t.Fatalf("log has escape codes: %q", log)
	}
}
