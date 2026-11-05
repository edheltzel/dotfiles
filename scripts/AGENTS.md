# scripts — shared shell helpers

## Purpose

Helper functions and setup scripts sourced by the installation flow. Not a stow package.

## Ownership

- `functions.sh` — logging/helpers: `error`, `info`, `warning`, `success` (colorized)
- `nvim.sh` — legacy LazyVim-starter clone helper. Not called by `install.sh`; Neovim config lives in the `neovim/` stow package.
- `link-herdr-app.sh` - shared by install/bootstrap, `just herdr-app`, `just stow config`, and `just update`. Links only personal Herdr files, backs up conflicting files under `$XDG_STATE_HOME/dotfiles/herdr-app` (default `~/.local/state`), and leaves runtime directories and generated files alone. Clone location is derived from the script, not `~/.dotfiles`.

## Local Contracts

- Other scripts source `functions.sh` for consistent output; guarded by `DOTFILES_FUNCTIONS_LOADED`.
- Use `set -e`, validate commands exist before use, fail fast with clear messages.

## Work Guidance

Keep helpers POSIX-friendly and side-effect free except where explicitly intended.

## Verification

`shellcheck functions.sh nvim.sh link-herdr-app.sh`.

`python3 scripts/test-herdr-app.py` from the repo root checks real linking and Stow in isolated homes, backups, repeat installs, generated-file exclusion, and theme switching.

## Child DOX Index

No children.
