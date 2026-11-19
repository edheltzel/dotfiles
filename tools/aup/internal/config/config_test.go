package config

import (
	"os"
	"path/filepath"
	"testing"
	"time"
)

func write(t *testing.T, body string) string {
	t.Helper()
	p := filepath.Join(t.TempDir(), "config.toml")
	if err := os.WriteFile(p, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	return p
}

func TestExampleConfigParses(t *testing.T) {
	steps, bad, err := Load("../../examples/config.toml")
	if err != nil || len(bad) != 0 || len(steps) != 3 {
		t.Fatalf("steps=%d bad=%v err=%v", len(steps), bad, err)
	}
	if steps[1].Installed != "codex" || len(steps[1].Args) != 3 || steps[1].Timeout == 0 {
		t.Fatalf("codex step=%+v", steps[1])
	}
}

func TestShippedManifestParses(t *testing.T) {
	path := "../../../../config/.config/aup/harnesses.toml"
	if _, err := os.Stat(path); err != nil {
		t.Skip("not inside the dotfiles repo")
	}
	steps, bad, err := Load(path)
	if err != nil || len(bad) != 0 || len(steps) == 0 {
		t.Fatalf("steps=%d bad=%v err=%v", len(steps), bad, err)
	}
	for _, s := range steps {
		if s.Label == "Plannotator" && len(s.Args) != 4 {
			t.Fatalf("list args not kept intact: %v", s.Args)
		}
	}
}

func TestStepAndLegacyTablesBothLoad(t *testing.T) {
	p := write(t, "[[step]]\nlabel = \"New\"\ncolor = \"fff000\"\nbinary = \"a\"\ninteractive = true\ntimeout = \"2m\"\nenv = { X = \"1\" }\n[[harness]]\nlabel = \"Old\"\ncolor = \"fff000\"\nbinary = \"b\"\n")
	steps, bad, err := Load(p)
	if err != nil || len(bad) != 0 || len(steps) != 2 {
		t.Fatalf("steps=%v bad=%v err=%v", steps, bad, err)
	}
	n := steps[0]
	if n.Label != "New" || !n.Interactive || n.Timeout != 2*time.Minute || n.Env["X"] != "1" || n.Installed != "a" || n.Version != "-" {
		t.Fatalf("step=%+v", n)
	}
	if steps[1].Label != "Old" {
		t.Fatalf("legacy row=%+v", steps[1])
	}
}

func TestBadFieldsAreRowErrors(t *testing.T) {
	p := write(t, "[[step]]\nlabel = \"A\"\ncolor = \"fff000\"\nbinary = \"a\"\ntimeout = \"soon\"\n[[step]]\nlabel = \"B\"\ncolor = \"fff000\"\nbinary = \"b\"\ninteractive = \"yes\"\n[[step]]\nlabel = \"C\"\n")
	steps, bad, err := Load(p)
	if err != nil || len(steps) != 0 || len(bad) != 3 {
		t.Fatalf("steps=%v bad=%v err=%v", steps, bad, err)
	}
	if bad[2].Error() != "step 3: missing color, binary" {
		t.Fatalf("bad=%v", bad)
	}
}

func TestPathPrefersFlagThenEnvThenXDG(t *testing.T) {
	home := t.TempDir()
	xdg := filepath.Join(home, "xdg")
	t.Setenv("XDG_CONFIG_HOME", xdg)
	t.Setenv("AUP_CONFIG", "")
	if got := Path("", home); got != filepath.Join(xdg, "aup/config.toml") {
		t.Fatalf("default=%s", got)
	}
	if err := os.MkdirAll(filepath.Join(xdg, "aup"), 0o755); err != nil {
		t.Fatal(err)
	}
	legacy := filepath.Join(xdg, "aup/harnesses.toml")
	if err := os.WriteFile(legacy, nil, 0o644); err != nil {
		t.Fatal(err)
	}
	if got := Path("", home); got != legacy {
		t.Fatalf("legacy=%s", got)
	}
	current := filepath.Join(xdg, "aup/config.toml")
	if err := os.WriteFile(current, nil, 0o644); err != nil {
		t.Fatal(err)
	}
	if got := Path("", home); got != current {
		t.Fatalf("current=%s", got)
	}
	t.Setenv("AUP_CONFIG", "/env.toml")
	if got := Path("", home); got != "/env.toml" {
		t.Fatalf("env=%s", got)
	}
	if got := Path("/flag.toml", home); got != "/flag.toml" {
		t.Fatalf("flag=%s", got)
	}
}
