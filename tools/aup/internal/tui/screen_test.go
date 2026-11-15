package tui

import (
	"strings"
	"testing"
)

func lines(chunks ...string) string {
	var s screen
	for _, c := range chunks {
		s.Write([]byte(c))
	}
	return strings.Join(s.Lines(), "|")
}

func TestScreen(t *testing.T) {
	cases := []struct {
		name   string
		chunks []string
		want   string
	}{
		{"plain lines", []string{"a\nb\n"}, "a|b"},
		{"partial line shows", []string{"a\nb"}, "a|b"},
		{"carriage return overwrites", []string{" 10%\r 50%\r100%\n"}, "100%"},
		{"crlf is a newline", []string{"a\r\nb\r\n"}, "a|b"},
		{"colour kept", []string{"\x1b[31mred\x1b[0m\n"}, "\x1b[31mred\x1b[0m"},
		{"cursor moves dropped", []string{"a\x1b[2Ab\x1b[?25l\n"}, "ab"},
		{"erase line clears", []string{"old\x1b[2Knew\n"}, "new"},
		{"escape split across chunks", []string{"x\x1b[3", "1my\n"}, "x\x1b[31my"},
		{"utf8 split across chunks", []string{"\xe2\x9c", "\x93\n"}, "\u2713"},
		{"osc title dropped", []string{"\x1b]0;title\x07ok\n"}, "ok"},
		{"backspace", []string{"ab\bc\n"}, "ac"},
	}
	for _, c := range cases {
		if got := lines(c.chunks...); got != c.want {
			t.Errorf("%s: got %q want %q", c.name, got, c.want)
		}
	}
}

func TestScreenCapsLines(t *testing.T) {
	var s screen
	for range maxLines + 10 {
		s.Write([]byte("x\n"))
	}
	if n := len(s.Lines()); n != maxLines {
		t.Fatalf("lines=%d", n)
	}
}
