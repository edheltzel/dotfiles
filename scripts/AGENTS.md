# scripts — shared shell helpers

## Purpose

Helper functions and setup scripts sourced by the installation flow. Not a stow package.

## Ownership

- `functions.sh` — logging/helpers: `error`, `info`, `warning`, `success` (colorized)
- `nvim.sh` — Neovim setup helper

## Local Contracts

- Other scripts source `functions.sh` for consistent output; guarded by `DOTFILES_FUNCTIONS_LOADED`.
- Use `set -e`, validate commands exist before use, fail fast with clear messages.

## Work Guidance

Keep helpers POSIX-friendly and side-effect free except where explicitly intended.

## Verification

`shellcheck functions.sh nvim.sh`.

## Child DOX Index

No children.
