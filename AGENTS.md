# Agent Guidelines — Dotfiles Repository

All agent guidelines are maintained in [CLAUDE.md](./CLAUDE.md). This file provides a quick-reference summary.

## Quick Reference

**What this is:** Fish shell macOS dotfiles (v3) managed with GNU Stow.

**Stow packages** (defined in `justfile:5`):

| Package | Path | Contents |
|---------|------|----------|
| dots | `dots/` | `$HOME` dotfiles (`.npmrc`, `.tmux.conf`, `.biome.json`, etc.) |
| git | `git/` | Git config, SSH signing, machine-specific locals |
| fish | `fish/` | Fish shell (XDG-compliant, lazy-loading, 80+ abbreviations) |
| config | `config/` | 25+ app configs (ghostty, kitty, yazi, lazygit, zed, etc.) |
| neoed | `neoed/` | Neovim config — **git submodule** ([repo](https://github.com/edheltzel/neoed)) |
| local | `local/` | `~/.local/` data (bin scripts, dictionaries, keyboard backups) |
| wezterm | `wezterm/` | WezTerm terminal (modular Lua: theme, tabs, statusbar, keymaps, workspaces) |

**Key commands:**

```bash
just run              # Stow all packages
just stow <pkg>       # Stow one package
just unstow <pkg>     # Unstow one package
just update           # Restow all (alias: just up)
just install          # Bootstrap new machine
```

**Code style:** EditorConfig enforced (2 spaces, LF, UTF-8). Shell uses `set -e`. Fish uses abbreviations not aliases. Lua uses 2-space indent, 120 char width.

**Two machines:** BigMac (desktop) and MacDaddy (MacBook). Machine-specific config via `.gitconfig.local` pattern.

**For full details:** See [CLAUDE.md](./CLAUDE.md) — architecture, conventions, troubleshooting, WezTerm keybindings, and more.
