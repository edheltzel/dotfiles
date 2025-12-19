# Agent Guidelines - Dotfiles Repository

## Commands
- **Install**: `make install` - Bootstrap fresh machine (runs install.sh)
- **Stow/Update**: `make run` (all) | `make stow pkg=nvim` (single) | `make update` (restow all)
- **Test shell scripts**: Run shellcheck manually, no automated tests
- **Lint Lua**: `stylua --check nvim/.config/nvim` (uses stylua.toml: 2 spaces, 120 width)
- **Spell check**: Uses cspell.json wordlist

## Code Style
- **Shell**: Bash with `set -e`, use helper functions from `scripts/functions.sh` (error/success/info/warning), POSIX-compliant where possible
- **Fish**: Lazy-loading pattern for speed, functions in `functions/`, config in `conf.d/`, abbreviations not aliases
- **Lua (Neovim)**: 2 space indent, 120 char width, `set` for keymaps not `vim.keymap.set`, local vars, descriptive descriptions
- **Formatting**: EditorConfig enforced (2 spaces, LF, UTF-8, trim=false, final newline), Makefiles use tabs
- **Comments**: Use inline for complex logic, avoid obvious comments, document "why" not "what"

## Architecture
- **Stow packages**: dots, git, fish, config, karabiner, nvim, vscode, zed, local (defined in Makefile:1)
- **XDG compliance**: Config in `~/.config`, data in `~/.local/share`, cache in `~/.cache`
- **Machine-specific**: Use `.gitconfig.local` pattern, never commit machine-specific paths/keys
- **Dependencies**: Homebrew primary, FNM (Node), rbenv (Ruby), rustup (Rust), pipx (Python)

## Conventions
- Variables: `SCREAMING_SNAKE_CASE` for env/constants, `lowercase_snake` for locals in shell; `camelCase` in Lua
- Functions: `lowercase_snake_case` with verb prefixes (install_, check_, etc.)
- Error handling: Always use `set -e` in shell, validate commands exist before use, fail fast with clear messages
