package tui

import (
	"image/color"
	"strings"
	"sync/atomic"

	"charm.land/lipgloss/v2"
)

var (
	accent      = lipgloss.Color("#B392D7")
	done        = lipgloss.Color("#5FD7A7")
	okStyle     = lipgloss.NewStyle().Foreground(done)
	badStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("#FF6B8B"))
	warn        = lipgloss.NewStyle().Foreground(lipgloss.Color("#F2C55C"))
	faint       = lipgloss.NewStyle().Foreground(lipgloss.Color("#7A7F99"))
	borderStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("#4A4E69"))
	titleStyle  = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("#1E1E2E")).Background(accent)
	selected    = lipgloss.NewStyle().Foreground(accent)
	pane        = lipgloss.NewStyle().Border(lipgloss.RoundedBorder()).BorderForeground(lipgloss.Color("#4A4E69")).Padding(0, 1)
)

func hex(s string) color.Color {
	s = strings.TrimPrefix(strings.TrimSpace(s), "#")
	if len(s) != 6 {
		return lipgloss.NoColor{}
	}
	return lipgloss.Color("#" + s)
}

type Size struct{ rows, cols atomic.Int32 }

func (s *Size) Set(rows, cols int) {
	s.rows.Store(int32(rows))
	s.cols.Store(int32(cols))
}

func (s *Size) Get() (rows, cols int) {
	return int(s.rows.Load()), int(s.cols.Load())
}
