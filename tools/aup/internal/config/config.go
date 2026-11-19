package config

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/BurntSushi/toml"
)

type Step struct {
	Label       string
	Color       string
	Binary      string
	Installed   string
	Version     string
	Args        []string
	Interactive bool
	Env         map[string]string
	Timeout     time.Duration
}

type RowError struct {
	Table string
	Row   int
	Msg   string
}

func (e RowError) Error() string { return fmt.Sprintf("%s %d: %s", e.Table, e.Row, e.Msg) }

var tables = []string{"step", "harness"}

func Path(flag, home string) string {
	if flag != "" {
		return flag
	}
	if p := os.Getenv("AUP_CONFIG"); p != "" {
		return p
	}
	dir := os.Getenv("XDG_CONFIG_HOME")
	if dir == "" {
		dir = filepath.Join(home, ".config")
	}
	current := filepath.Join(dir, "aup", "config.toml")
	if _, err := os.Stat(current); err == nil {
		return current
	}
	legacy := filepath.Join(dir, "aup", "harnesses.toml")
	if _, err := os.Stat(legacy); err == nil {
		return legacy
	}
	return current
}

func Load(path string) (steps []Step, bad []RowError, err error) {
	var doc map[string]any
	if _, err := toml.DecodeFile(path, &doc); err != nil {
		return nil, nil, err
	}
	for _, table := range tables {
		rows, ok := doc[table].([]map[string]any)
		if !ok && doc[table] != nil {
			return nil, nil, errors.New(table + " must be an array of tables")
		}
		for i, row := range rows {
			s, msg := parse(row)
			if msg != "" {
				bad = append(bad, RowError{table, i + 1, msg})
				continue
			}
			steps = append(steps, s)
		}
	}
	return steps, bad, nil
}

func parse(row map[string]any) (Step, string) {
	s := Step{
		Label:     field(row["label"]),
		Color:     field(row["color"]),
		Binary:    field(row["binary"]),
		Installed: field(row["installed"]),
		Version:   field(row["version"]),
	}
	var missing []string
	for _, c := range [][2]string{{"label", s.Label}, {"color", s.Color}, {"binary", s.Binary}} {
		if c[1] == "" {
			missing = append(missing, c[0])
		}
	}
	if len(missing) > 0 {
		return s, "missing " + strings.Join(missing, ", ")
	}
	if s.Installed == "" {
		s.Installed = s.Binary
	}
	if s.Version == "" {
		s.Version = "-"
	}
	switch a := row["args"].(type) {
	case nil:
	case string:
		s.Args = strings.Fields(a)
	case []any:
		for _, x := range a {
			s.Args = append(s.Args, fmt.Sprint(x))
		}
	default:
		return s, "args must be a string or list"
	}
	switch v := row["interactive"].(type) {
	case nil:
	case bool:
		s.Interactive = v
	default:
		return s, "interactive must be true or false"
	}
	switch v := row["env"].(type) {
	case nil:
	case map[string]any:
		s.Env = map[string]string{}
		for k, x := range v {
			s.Env[k] = fmt.Sprint(x)
		}
	default:
		return s, "env must be a table"
	}
	if v, ok := row["timeout"]; ok {
		d, err := time.ParseDuration(field(v))
		if err != nil || d <= 0 {
			return s, "timeout must be a duration like \"10m\""
		}
		s.Timeout = d
	}
	return s, ""
}

func field(v any) string {
	if v == nil {
		return ""
	}
	return strings.TrimSpace(fmt.Sprint(v))
}
