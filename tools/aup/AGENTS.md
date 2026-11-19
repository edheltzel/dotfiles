# tools/aup

## Purpose

Go source of the `aup` updater CLI (module `github.com/edheltzel/aup`), staged here until it moves to its own repo. Plan: `.agents/atlas/plans/aup-standalone-tui-cli.md`.

## Ownership

- Owns `tools/aup/**`. The personal step list stays in `config/.config/aup/harnesses.toml` (stowed to `~/.config/aup/`).
- `fish/.config/fish/functions/aup.fish` is a separate fish implementation that shadows this binary inside fish until the migration retires it.

## Local Contracts

- `internal/runner` never imports a UI package. Plain and TUI output are both driven by `runner.Sink` events.
- Plain mode output is a contract: the tests in `internal/cli/cli_test.go` pin it. Change it only on purpose and update those tests.
- The TUI starts only when stdin and stdout are terminals, `CI` is unset, `TERM` is not `dumb`, and neither `--plain` nor `--dry-run` (without `--tui`) is set.
- The log at `~/.local/state/aup/last.log` never contains escape codes.
- `.github/` and `.goreleaser.yaml` here are for the future standalone repo; they do not run from the dotfiles repo.

## Work Guidance

- Build and install with `just aup`.
- After a deliberate TUI change, refresh snapshots with `go test ./internal/tui -run TestViewGolden -update` and read the diff.

## Verification

- `cd tools/aup && go vet ./... && go test -race ./...`

## Child DOX Index

None.
