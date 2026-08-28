# zsh — secondary shell config (stow package)

## Purpose

Zsh configuration kept as a secondary/fallback shell. Fish is the primary shell (v3); zsh remains stowed for compatibility.

## Ownership

`.zshenv` and `.config/zsh/`.

## Local Contracts

- Stowed via `just stow zsh`.
- `AGENTS.md` is excluded from stow via the shared global ignore (`~/.stow-global-ignore`).

## Work Guidance

(none — primary shell work belongs in the `fish` package)

## Verification

(none)

## Child DOX Index

No children.
