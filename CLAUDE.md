# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Fish shell-based macOS dotfiles (v3) using **GNU Stow** for symlink management. Modular, package-based architecture with XDG Base Directory compliance.

**Key Design Principles:**
- Non-invasive symlink-based configuration
- Performance-optimized shell with lazy-loading
- Machine-independent design with local overrides

## Commands

### Dotfile Management (Makefile)

```bash
make install        # Bootstrap new machine (runs install.sh)
make run            # Symlink all packages
make stow pkg=fish  # Add specific package
make unstow pkg=fish # Remove specific package
make update         # Restow all + clean dead symlinks
make delete         # Remove all symlinks
```

### Testing & Linting

```bash
shellcheck <script>                      # Lint shell scripts (manual)
stylua --check neoed/.config/nvim        # Lint Neovim Lua (2 spaces, 120 width)
```

### Common Aliases/Abbreviations

```bash
upp                 # Update all packages (topgrade)
reload              # Reload fish config
nvim                # Primary editor
zz                  # Zed in new window
eva                 # Start SSH agent + add key to keychain

# AI Tools
cc                  # Claude Code (--dangerously-skip-permissions)
ccc                 # Claude Converse mode (--dangerously-skip-permissions)
ccu                 # Claude Code usage stats (bunx ccusage)
```

## Architecture

### Stow Packages

| Package | Purpose |
|---------|---------|
| **atlas** | Personal AI Infrastructure - Git Submodule ([repo](https://github.com/edheltzel/atlas)) |
| **neoed** | Neovim/LazyVim config - Git Submodule ([repo](https://github.com/edheltzel/neoed)) |
| **fish** | Fish shell config (XDG-compliant, lazy-loading) |
| **git** | Git config with SSH signing |
| **config** | 27+ app configs (terminals, multiplexers, tools) |
| **dots** | Misc home directory dotfiles |
| **local** | User-specific non-config data |

**Git Submodules:** Run `git submodule update --init --recursive` after cloning.

### Fish Shell Structure (`fish/.config/fish/`)

- `config.fish` - Minimal bootstrap for fast startup
- `conf.d/` - Auto-loaded modular configs (abbr, paths, exports, fnm, zoxide)
- `functions/` - Custom functions
- `completions/` - Fish completions (voicemode, etc.)
- `conf.d/secrets.fish` - API keys (gitignored, create from `secrets.fish.example`)

**Lazy-loading:** FNM and Zoxide initialize on first use, not at shell startup.

### Key Files

- `Makefile` - Primary interface for dotfile operations
- `install.sh` - Main installation orchestrator
- `packages/Brewfile` - Homebrew packages/casks/fonts
- `scripts/functions.sh` - Helper functions (error/success/info/warning with colors)

## Code Style

**Shell Scripts:**
- Use `set -e` for error handling
- POSIX-compliant where possible
- Use helper functions from `scripts/functions.sh`

**Fish:**
- Abbreviations (not aliases) for better composability
- Functions in `functions/`, configs in `conf.d/`
- Lazy-loading pattern for heavy tools

**Lua (Neovim):**
- 2 space indent, 120 char width
- Use `set` for keymaps (not `vim.keymap.set`)
- Local vars, descriptive descriptions

**Formatting:**
- EditorConfig enforced: 2 spaces, LF, UTF-8, final newline
- Makefiles use tabs
- Comments: document "why" not "what"

## Conventions

- **Variables:** `SCREAMING_SNAKE_CASE` for env/constants, `lowercase_snake` for locals in shell; `camelCase` in Lua
- **Functions:** `lowercase_snake_case` with verb prefixes (install*, check*, etc.)
- **Error handling:** Always validate commands exist before use, fail fast with clear messages

## Machine-Specific Configuration

- Use `.gitconfig.local` pattern (never commit machine-specific data)
- Per-machine files provisioned by `git/git.sh`
- Secrets in `fish/.config/fish/conf.d/secrets.fish` (gitignored)

## Git Configuration

**SSH Signing (not GPG):**
- Uses SSH keys for commit/tag signing
- Machine-specific config in `.gitconfig.local`
- Run `git/git.sh` on new machine to provision

**Useful Aliases:**
```bash
git cm "msg"    # Signed commit
git cma "msg"   # Add all + signed commit
git addi        # Interactive add with fzf
git logs        # Pretty graph log
git sm          # Submodule update --init --recursive
```

## Troubleshooting

**Stow Conflicts:** `make delete && make run`

**SSH Agent Issues:** `eva` (alias for eval ssh-agent + ssh-add)

**FNM/Node Issues:** `fnm env --use-on-cd | source`

**Fisher Plugin Issues:**
```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

**Cargo/Rust Failures:**
```bash
brew uninstall rustup-init && brew reinstall rust && cargo install cargo-update --force
```

## WezTerm Configuration

WezTerm config uses a modular architecture (`config/.config/wezterm/`):
- `wezterm.lua` - Main orchestrator
- `keymaps.lua` - Leader key (`cmd+k`) and all keybindings
- `theme.lua`, `tabs.lua`, `statusbar.lua`, `workspaces.lua` - Modular components

**Key WezTerm Keybindings:**
```lua
-- Leader key: cmd+k (1.5s timeout)
cmd+k z             -- Toggle zen mode in current window (adds padding, hides tab bar)
cmd+k Z             -- Spawn new dedicated zen window
cmd+k n             -- New window
cmd+k t             -- New tab
cmd+k x             -- Close pane/tab
cmd+k -             -- Split vertical
cmd+k \             -- Split horizontal
cmd+k h/j/l/u       -- Split left/down/right/up (Ghostty-style)
cmd+k r             -- Resize pane mode (h/j/k/l to resize)
cmd+k s             -- Switch workspace (fuzzy)
cmd+k S             -- Create new workspace
cmd+k =             -- Toggle pane zoom
cmd+k c             -- Copy mode
cmd+k 1-9           -- Jump to tab by index
```

**Zen Mode:** Adds 25% horizontal padding and hides tab bar for focused writing. Two variants:
- `toggle-zen-mode`: Toggles in current window (affects all tabs)
- `spawn-zen-window`: Creates new isolated zen window preserving cwd
