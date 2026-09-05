# zsh — secondary shell config (stow package)

## Purpose

Zsh configuration kept as a secondary/fallback shell. Fish is the primary shell (v3); zsh remains stowed for compatibility.

## Ownership

- `.zshenv` (sets `ZDOTDIR=~/.config/zsh`) and `.config/zsh/`
- `.zshrc` — Antidote bootstrap, prompt selection (`ZSH_PROMPT`, Starship default)
- `.zshrc.d/` — numbered modules loaded in order (`01-paths` … `12-lazy-zoxide`), mirroring fish `conf.d/`
- `.zsh_plugins.txt` — Antidote plugin list
- `functions/`, `completions/` — ports of the fish equivalents
- `secrets.zsh.example` — template for gitignored `secrets.zsh`

## Local Contracts

- Stowed via `just stow zsh`.
- `AGENTS.md` is excluded from stow via the shared global ignore (`~/.stow-global-ignore`).

## Work Guidance

(none — primary shell work belongs in the `fish` package)

## Verification

(none)

## Child DOX Index

No children.
