package tui

import (
	"context"
	"io"
	"os/exec"
	"sync"

	tea "charm.land/bubbletea/v2"
	"github.com/creack/pty"

	"github.com/edheltzel/aup/internal/runner"
)

type execMsg struct {
	cmd    *exec.Cmd
	result chan error
}

type Sender interface{ Send(tea.Msg) }

type Bridge struct {
	Program Sender
	Log     runner.Sink
	LogOut  io.Writer
	Size    *Size

	mu   sync.Mutex
	kill func()
}

func (b *Bridge) Started(i int, t runner.Task) {
	b.Log.Started(i, t)
	b.Program.Send(StartedMsg{I: i})
}

func (b *Bridge) Command(i int, t runner.Task, cmd *exec.Cmd) runner.Exec {
	b.Log.Command(i, t, cmd)
	if t.Interactive {
		return b.interactive
	}
	return func(ctx context.Context, cmd *exec.Cmd, _ runner.Task) error { return b.pty(ctx, i, cmd) }
}

func (b *Bridge) Done(i int, t runner.Task, r runner.Result) {
	b.Log.Done(i, t, r)
	b.Program.Send(DoneMsg{I: i, Result: r})
}

func (b *Bridge) CancelStep() {
	b.mu.Lock()
	defer b.mu.Unlock()
	if b.kill != nil {
		b.kill()
	}
}

func (b *Bridge) setKill(f func()) {
	b.mu.Lock()
	b.kill = f
	b.mu.Unlock()
}

func (b *Bridge) interactive(_ context.Context, cmd *exec.Cmd, _ runner.Task) error {
	cmd.Stdin, cmd.Stdout, cmd.Stderr = nil, nil, nil
	ch := make(chan error, 1)
	b.Program.Send(execMsg{cmd: cmd, result: ch})
	return <-ch
}

func (b *Bridge) pty(ctx context.Context, i int, cmd *exec.Cmd) error {
	cmd.Stdin, cmd.Stdout, cmd.Stderr = nil, nil, nil
	size := &pty.Winsize{Rows: 24, Cols: 80}
	if b.Size != nil {
		if rows, cols := b.Size.Get(); rows > 0 && cols > 0 {
			size = &pty.Winsize{Rows: uint16(rows), Cols: uint16(cols)}
		}
	}
	f, err := pty.StartWithSize(cmd, size)
	if err != nil {
		return err
	}
	defer f.Close()
	var cancelled bool
	b.setKill(func() {
		cancelled = true
		_ = cmd.Process.Kill()
	})
	defer b.setKill(nil)
	copied := make(chan struct{})
	go func() {
		defer close(copied)
		buf := make([]byte, 32*1024)
		for {
			n, err := f.Read(buf)
			if n > 0 {
				chunk := append([]byte(nil), buf[:n]...)
				if b.LogOut != nil {
					_, _ = b.LogOut.Write(chunk)
				}
				b.Program.Send(OutputMsg{I: i, Data: chunk})
			}
			if err != nil {
				return
			}
		}
	}()
	werr := cmd.Wait()
	<-copied
	b.mu.Lock()
	wasCancelled := cancelled
	b.mu.Unlock()
	if wasCancelled && ctx.Err() == nil {
		return runner.ErrCancelled
	}
	return werr
}
