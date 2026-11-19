package tui

import (
	"fmt"
	"strings"
	"time"

	"charm.land/bubbles/v2/help"
	"charm.land/bubbles/v2/key"
	"charm.land/bubbles/v2/progress"
	"charm.land/bubbles/v2/spinner"
	"charm.land/bubbles/v2/viewport"
	tea "charm.land/bubbletea/v2"
	"charm.land/lipgloss/v2"
	"charm.land/lipgloss/v2/table"

	"github.com/edheltzel/aup/internal/runner"
)

type status int

const (
	pending status = iota
	running
	succeeded
	failed
	skipped
)

type StartedMsg struct{ I int }

type OutputMsg struct {
	I    int
	Data []byte
}

type DoneMsg struct {
	I      int
	Result runner.Result
}

type FinishedMsg struct{}

type tickMsg time.Time

type row struct {
	label, color string
	dups         []string
	status       status
	result       runner.Result
	out          screen
	began, ended time.Time
}

type keyMap struct {
	Up, Down, Follow, Cancel, Quit, Close key.Binding
}

func newKeys() keyMap {
	return keyMap{
		Up:     key.NewBinding(key.WithKeys("k", "up"), key.WithHelp("k/\u2191", "prev step")),
		Down:   key.NewBinding(key.WithKeys("j", "down"), key.WithHelp("j/\u2193", "next step")),
		Follow: key.NewBinding(key.WithKeys("f"), key.WithHelp("f", "follow")),
		Cancel: key.NewBinding(key.WithKeys("ctrl+c"), key.WithHelp("ctrl+c", "cancel step")),
		Quit:   key.NewBinding(key.WithKeys("q"), key.WithHelp("q", "quit")),
		Close:  key.NewBinding(key.WithKeys("q", "enter", "esc", "ctrl+c"), key.WithHelp("enter", "close")),
	}
}

type Options struct {
	CancelStep func()
	Abort      func()
	LogPath    string
	Size       *Size
	Now        func() time.Time
}

type Model struct {
	opts                   Options
	rows                   []row
	tasks                  int
	sel, current           int
	follow, done, quitting bool
	width, height          int
	start, now             time.Time
	spin                   spinner.Model
	bar                    progress.Model
	vp                     viewport.Model
	help                   help.Model
	keys                   keyMap
}

func New(plan runner.Plan, opts Options) *Model {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	m := &Model{
		opts:    opts,
		tasks:   len(plan.Tasks),
		current: -1,
		follow:  true,
		width:   100,
		height:  30,
		spin:    spinner.New(spinner.WithSpinner(spinner.MiniDot), spinner.WithStyle(lipgloss.NewStyle().Foreground(accent))),
		bar:     progress.New(progress.WithColors(accent, done), progress.WithoutPercentage()),
		vp:      viewport.New(),
		help:    help.New(),
		keys:    newKeys(),
	}
	for _, t := range plan.Tasks {
		m.rows = append(m.rows, row{label: t.Label, color: t.Color, dups: t.Dups})
	}
	for _, s := range plan.Missing {
		m.rows = append(m.rows, row{label: s.Label, color: s.Color, status: skipped})
	}
	m.start = opts.Now()
	m.now = m.start
	m.layout()
	return m
}

func tick() tea.Cmd {
	return tea.Tick(time.Second, func(t time.Time) tea.Msg { return tickMsg(t) })
}

func (m *Model) Init() tea.Cmd { return tea.Batch(m.spin.Tick, tick()) }

func (m *Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width, m.height = msg.Width, msg.Height
		m.layout()
	case tickMsg:
		m.now = m.opts.Now()
		if !m.done {
			return m, tick()
		}
	case spinner.TickMsg:
		var cmd tea.Cmd
		m.spin, cmd = m.spin.Update(msg)
		return m, cmd
	case StartedMsg:
		r := &m.rows[msg.I]
		r.status, r.began = running, m.opts.Now()
		m.current = msg.I
		if m.follow {
			m.sel = msg.I
		}
		m.refresh()
	case OutputMsg:
		m.rows[msg.I].out.Write(msg.Data)
		if msg.I == m.sel {
			m.refresh()
		}
	case DoneMsg:
		r := &m.rows[msg.I]
		r.result, r.ended = msg.Result, m.opts.Now()
		r.status = succeeded
		if !msg.Result.OK() {
			r.status = failed
		}
		if m.current == msg.I {
			m.current = -1
		}
		m.refresh()
	case FinishedMsg:
		m.done = true
		m.now = m.opts.Now()
		if m.quitting {
			return m, tea.Quit
		}
		m.layout()
	case execMsg:
		return m, tea.ExecProcess(msg.cmd, func(err error) tea.Msg {
			msg.result <- err
			return nil
		})
	case tea.KeyPressMsg:
		return m, m.key(msg)
	}
	return m, nil
}

func (m *Model) key(msg tea.KeyPressMsg) tea.Cmd {
	if m.done {
		if key.Matches(msg, m.keys.Close) {
			return tea.Quit
		}
	}
	switch {
	case key.Matches(msg, m.keys.Cancel):
		if m.current >= 0 && m.opts.CancelStep != nil {
			m.opts.CancelStep()
		}
	case key.Matches(msg, m.keys.Quit):
		m.quitting = true
		if m.opts.Abort != nil {
			m.opts.Abort()
		}
		if m.done {
			return tea.Quit
		}
	case key.Matches(msg, m.keys.Up):
		m.move(-1)
	case key.Matches(msg, m.keys.Down):
		m.move(1)
	case key.Matches(msg, m.keys.Follow):
		m.follow = true
		if m.current >= 0 {
			m.sel = m.current
		}
		m.refresh()
	default:
		var cmd tea.Cmd
		m.vp, cmd = m.vp.Update(msg)
		return cmd
	}
	return nil
}

func (m *Model) move(d int) {
	n := m.sel + d
	if n < 0 || n >= len(m.rows) {
		return
	}
	m.sel, m.follow = n, false
	m.refresh()
}

func (m *Model) listWidth() int {
	w := 24
	for _, r := range m.rows {
		w = max(w, lipgloss.Width(r.label)+24)
	}
	return min(w, max(m.width/2, 24))
}

func (m *Model) paneHeight() int { return max(m.height-3, 6) }

func (m *Model) layout() {
	body := m.paneHeight() - 3
	right := max(m.width-m.listWidth()-4, 10)
	m.vp.SetWidth(right)
	m.vp.SetHeight(body)
	m.bar.SetWidth(max(m.width-8, 10))
	if m.opts.Size != nil {
		m.opts.Size.Set(body, right)
	}
	m.refresh()
}

func (m *Model) refresh() {
	if len(m.rows) == 0 {
		return
	}
	r := &m.rows[m.sel]
	var content []string
	switch {
	case r.status == skipped:
		content = []string{faint.Render("Not installed. Nothing to run.")}
	case len(r.dups) > 0:
		content = append([]string{warn.Render("warning: installed more than once: " + strings.Join(r.dups, ", ")), ""}, r.out.Lines()...)
	default:
		content = r.out.Lines()
	}
	if len(content) == 0 && r.status == pending {
		content = []string{faint.Render("Waiting to run.")}
	}
	m.vp.SetContentLines(content)
	if m.follow || r.status == running {
		m.vp.GotoBottom()
	}
}

func (m *Model) counts() (ok, bad, skip, finished int) {
	for _, r := range m.rows {
		switch r.status {
		case succeeded:
			ok++
		case failed:
			bad++
		case skipped:
			skip++
		}
	}
	return ok, bad, skip, ok + bad
}

func (m *Model) View() tea.View {
	v := tea.NewView(m.render())
	v.AltScreen = true
	v.WindowTitle = "aup"
	return v
}

func (m *Model) render() string {
	ok, bad, _, finished := m.counts()
	elapsed := m.now.Sub(m.start).Round(time.Second)
	title := titleStyle.Render(" aup ") + " " + faint.Render("agent harness updater")
	stat := fmt.Sprintf("%d/%d  %s", finished, m.tasks, clock(elapsed))
	header := lipgloss.JoinHorizontal(lipgloss.Top, title, strings.Repeat(" ", max(m.width-lipgloss.Width(title)-lipgloss.Width(stat), 1)), faint.Render(stat))
	var body string
	if m.done {
		body = m.summary(ok, bad)
	} else {
		body = lipgloss.JoinHorizontal(lipgloss.Top, m.list(), m.output())
	}
	pct := 1.0
	if m.tasks > 0 {
		pct = float64(finished) / float64(m.tasks)
	}
	bar := " " + m.bar.ViewAs(pct) + fmt.Sprintf(" %3.0f%%", pct*100)
	keys := []key.Binding{m.keys.Up, m.keys.Down, m.keys.Follow, m.keys.Cancel, m.keys.Quit}
	if m.done {
		keys = []key.Binding{m.keys.Close}
	}
	return lipgloss.JoinVertical(lipgloss.Left, header, body, bar, " "+m.help.ShortHelpView(keys))
}

func (m *Model) list() string {
	w := m.listWidth()
	var lines []string
	for i, r := range m.rows {
		mark, note := m.mark(r)
		label := lipgloss.NewStyle().Foreground(hex(r.color)).Render(r.label)
		if r.status == skipped {
			label = faint.Render(r.label)
		}
		pointer := "  "
		if i == m.sel {
			pointer = selected.Render("\u258c ")
		}
		line := pointer + mark + " " + label
		if note != "" {
			line += strings.Repeat(" ", max(w-4-lipgloss.Width(line)-lipgloss.Width(note), 1)) + note
		}
		lines = append(lines, line)
	}
	return pane.Width(w).Height(m.paneHeight()).Render(strings.Join(lines, "\n"))
}

func (m *Model) mark(r row) (string, string) {
	switch r.status {
	case running:
		return m.spin.View(), faint.Render(clock(m.now.Sub(r.began).Round(time.Second)))
	case succeeded:
		note := ""
		if r.result.After != "" && r.result.Before != r.result.After && r.result.Before != "" {
			note = r.result.Before + "\u2192" + r.result.After
		} else if r.result.After != "" {
			note = r.result.After
		}
		return okStyle.Render("\u2713"), faint.Render(note)
	case failed:
		if r.result.Cancelled {
			return badStyle.Render("\u2717"), badStyle.Render("cancelled")
		}
		return badStyle.Render("\u2717"), badStyle.Render(fmt.Sprintf("exit %d", r.result.Code))
	case skipped:
		return faint.Render("\u2013"), faint.Render("not installed")
	}
	if len(r.dups) > 0 {
		return warn.Render("\u26a0"), warn.Render("2+ installs")
	}
	return faint.Render("\u00b7"), ""
}

func (m *Model) output() string {
	r := m.rows[m.sel]
	title := lipgloss.NewStyle().Bold(true).Foreground(hex(r.color)).Render(" " + r.label + " ")
	return pane.Width(m.vp.Width() + 4).Height(m.paneHeight()).Render(title + "\n" + m.vp.View())
}

func (m *Model) summary(ok, bad int) string {
	t := table.New().Border(lipgloss.RoundedBorder()).BorderStyle(borderStyle).Headers("Step", "Result", "Version").
		StyleFunc(func(row, _ int) lipgloss.Style {
			if row == table.HeaderRow {
				return lipgloss.NewStyle().Bold(true).Padding(0, 1)
			}
			return lipgloss.NewStyle().Padding(0, 1)
		})
	for _, r := range m.rows {
		res, ver := "", ""
		switch r.status {
		case succeeded:
			res = okStyle.Render("updated")
			switch {
			case r.result.After == "":
			case r.result.Before == "" || r.result.Before == r.result.After:
				ver = r.result.After
			default:
				ver = r.result.Before + " \u2192 " + r.result.After
			}
		case failed:
			res = badStyle.Render(fmt.Sprintf("failed (exit %d)", r.result.Code))
			if r.result.Cancelled {
				res = badStyle.Render("cancelled")
			}
		case skipped:
			res = faint.Render("not installed")
		default:
			res = faint.Render("not run")
		}
		t.Row(lipgloss.NewStyle().Foreground(hex(r.color)).Render(r.label), res, ver)
	}
	_, _, skip, _ := m.counts()
	line := fmt.Sprintf("%d updated, %d failed, %d skipped.", ok, bad, skip)
	if bad > 0 {
		line = badStyle.Render(line)
	}
	parts := []string{t.String(), " " + line}
	if m.opts.LogPath != "" {
		parts = append(parts, faint.Render(" log: "+m.opts.LogPath))
	}
	return lipgloss.NewStyle().Height(m.paneHeight()).Render(lipgloss.JoinVertical(lipgloss.Left, parts...))
}

func clock(d time.Duration) string {
	return fmt.Sprintf("%02d:%02d", int(d.Minutes()), int(d.Seconds())%60)
}
