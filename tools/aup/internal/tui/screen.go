package tui

import (
	"regexp"
	"strings"
	"unicode/utf8"
)

const maxLines = 5000

var (
	csiRe = regexp.MustCompile(`^\x1b\[([0-9;?]*)([ -/]*)([@-~])`)
	oscRe = regexp.MustCompile(`^\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)`)
)

type screen struct {
	lines   []string
	cur     strings.Builder
	cr      bool
	pending []byte
}

func (s *screen) Write(p []byte) {
	data := append(s.pending, p...)
	s.pending = nil
	for len(data) > 0 {
		switch b := data[0]; {
		case b == 0x1b:
			n, keep, done := escape(data)
			if !done {
				s.pending = append([]byte(nil), data...)
				return
			}
			seq := data[:n]
			data = data[n:]
			switch {
			case keep:
				s.text(string(seq))
			case len(seq) > 2 && seq[1] == '[' && seq[len(seq)-1] == 'K':
				s.cur.Reset()
				s.cr = false
			}
		case b == '\n':
			s.newline()
			data = data[1:]
		case b == '\r':
			s.cr = true
			data = data[1:]
		case b == '\b':
			line := s.cur.String()
			if _, size := utf8.DecodeLastRuneInString(line); size > 0 {
				s.cur.Reset()
				s.cur.WriteString(line[:len(line)-size])
			}
			data = data[1:]
		case b == '\t':
			s.text("    ")
			data = data[1:]
		case b < 0x20 || b == 0x7f:
			data = data[1:]
		default:
			r, size := utf8.DecodeRune(data)
			if r == utf8.RuneError && size <= 1 && !utf8.FullRune(data) {
				s.pending = append([]byte(nil), data...)
				return
			}
			s.text(string(data[:size]))
			data = data[size:]
		}
	}
}

func escape(data []byte) (n int, keep, done bool) {
	if len(data) < 2 {
		return 0, false, false
	}
	switch data[1] {
	case '[':
		m := csiRe.Find(data)
		if m == nil {
			if len(data) > 64 {
				return 1, false, true
			}
			return 0, false, false
		}
		return len(m), m[len(m)-1] == 'm', true
	case ']':
		m := oscRe.Find(data)
		if m == nil {
			if len(data) > 512 {
				return 1, false, true
			}
			return 0, false, false
		}
		return len(m), false, true
	default:
		return 2, false, true
	}
}

func (s *screen) text(t string) {
	if s.cr {
		s.cur.Reset()
		s.cr = false
	}
	s.cur.WriteString(t)
}

func (s *screen) newline() {
	s.cr = false
	s.lines = append(s.lines, s.cur.String())
	s.cur.Reset()
	if over := len(s.lines) - maxLines; over > 0 {
		s.lines = append([]string(nil), s.lines[over:]...)
	}
}

func (s *screen) Lines() []string {
	if s.cur.Len() == 0 {
		return s.lines
	}
	return append(append([]string(nil), s.lines...), s.cur.String())
}
