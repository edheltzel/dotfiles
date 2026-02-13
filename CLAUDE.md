# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and AI coding agents when working with code in this repository.

## Repository Overview

Fish shell-based macOS dotfiles (v3) using **GNU Stow** for symlink management. Modular, package-based architecture with XDG Base Directory compliance.

**Key Philosophy:**
- Non-invasive symlink-based configuration management
- XDG Base Directory compliance to keep `~` clean
- Multi-editor strategy (Neovim primary, Zed secondary)
- Performance-optimized shell with lazy-loading patterns
- Machine-independent design with local overrides

## Commands

### Dotfile Management (Makefile)

```bash
make install        # Bootstrap new machine (runs install.sh)
make run            # Symlink all packages
make stow pkg=fish  # Add specific package
make unstow pkg=fish # Remove specific package
make update         # Restow all + clean dead symlinks (also: make up)
make delete         # Remove all symlinks
```

### Testing & Linting

```bash
shellcheck <script>                      # Lint shell scripts (manual, no automated tests)
stylua --check neoed/.config/nvim        # Lint Neovim Lua (uses stylua.toml: 2 spaces, 120 width)
```

### Package Management

```bash
upp                 # Update ALL packages and dependencies (topgrade)

# Package listing commands
brews               # List Homebrew packages
casks               # List Homebrew casks
npms                # List global npm packages
cargos              # List Cargo packages
gems                # List Ruby gems
```

### Development Workflow

```bash
# Node version management (FNM)
fnm use                    # Switch to .node-version or .nvmrc
fnm env --use-on-cd | source  # Enable auto-switching

# Git shortcuts (extensive aliases in .gitconfig)
git cm "message"           # Signed commit
git cma "message"          # Add all + signed commit
git addi                   # Interactive add with fzf
git logs                   # Pretty git log graph
git sm                     # Submodule update --init --recursive

# Editors
nvim                       # Primary editor (LazyVim-based NEO.ED)
zed -n .                   # Zed in new window (alias: zz)
code -r .                  # VSCode reuse window (alias: coo)

# Shell
reload                     # Reload Fish configuration
eva                        # Start SSH agent + add key to keychain
```

### AI Tools

```bash
cc                  # Claude Code (--dangerously-skip-permissions)
ccc                 # Claude Converse mode (--dangerously-skip-permissions)
ccu                 # Claude Code usage stats (bunx ccusage)
```

## Code Style

**Shell Scripts:**
- Use `set -e` for error handling
- POSIX-compliant where possible
- Use helper functions from `scripts/functions.sh` (error/success/info/warning)

**Fish:**
- Abbreviations (not aliases) for better composability
- Functions in `functions/`, configs in `conf.d/`
- Lazy-loading pattern for heavy tools

**Lua (Neovim):**
- 2 space indent, 120 char width
- Use `set` for keymaps (not `vim.keymap.set`)
- Local vars, descriptive descriptions

**Formatting:**
- EditorConfig enforced: 2 spaces, LF, UTF-8, trim=false, final newline
- Makefiles use tabs
- Comments: use inline for complex logic, avoid obvious comments, document "why" not "what"

## Conventions

- **Variables:** `SCREAMING_SNAKE_CASE` for env/constants, `lowercase_snake` for locals in shell; `camelCase` in Lua
- **Functions:** `lowercase_snake_case` with verb prefixes (install*, check*, etc.)
- **Error handling:** Always use `set -e` in shell, validate commands exist before use, fail fast with clear messages
- **Plans:** All implementation plans must be saved to `.claude/plans/` as Markdown files. Use descriptive filenames (e.g., `add-zellij-config.md`, `refactor-fish-abbr.md`). This applies to all agents — plan mode, subagents, and manual planning alike.

## Architecture

### Stow Packages

The repository uses these stow packages (defined in `Makefile:1`):

- **atlas** - Personal AI Infrastructure (PAI) - **Git Submodule** ([repo](https://github.com/edheltzel/atlas))
  - Claude Code: hooks, skills, commands, voice system, observability dashboard
  - OpenCode: agents, commands, plugins, themes
  - Symlinks to `~/.claude/` and `~/.config/opencode/`
- **neoed** - LazyVim customizations (NEO.ED) - **Git Submodule** ([repo](https://github.com/edheltzel/neoed))
- **fish** - Fish shell config (XDG-compliant, lazy-loading)
- **git** - Git configuration with SSH signing
- **config** - 27+ application configs (yazi, raycast, aerospace, karabiner, zed, etc.)
- **dots** - Misc dotfiles in `$HOME` (`.npmrc`, `.curlrc`, etc.)
- **local** - User-specific non-config data

**Git Submodules:** Both `atlas` and `neoed` are managed as separate repositories. After cloning, run `git submodule update --init --recursive` to initialize them.

### Atlas - Personal AI Infrastructure

The `atlas/` submodule contains the Personal AI Infrastructure (PAI) for Claude Code and OpenCode:

| Directory | Purpose |
|-----------|---------|
| `atlas/.claude/commands/atlas/` | 18 slash commands (`/atlas:*`) |
| `atlas/.claude/skills/` | 7 skills (CORE, Art, Agents, Browser, Prompting, etc.) |
| `atlas/.claude/hooks/` | TypeScript session lifecycle hooks |
| `atlas/.claude/voice/` | ElevenLabs TTS voice server |
| `atlas/.claude/observability/` | Real-time Vue dashboard |
| `atlas/.config/opencode/` | OpenCode AI configuration |

**Working with Atlas:**

```bash
# Update atlas submodule
cd ~/.dotfiles/atlas && git pull origin master

# Restow after changes
make stow pkg=atlas
```

**Atlas Commands:** Run `/atlas:help` in Claude Code to see all available commands.

### XDG Compliance

All paths configured in `fish/.config/fish/conf.d/paths.fish`:

- Config: `~/.config`
- Data: `~/.local/share`
- Cache: `~/.cache`
- Local: `~/.local`

### Fish Shell Structure (`fish/.config/fish/`)

**Performance Pattern:** Minimal `config.fish` with lazy-loading

- `config.fish` - Ultra-minimal for fast startup
- `conf.d/` - Auto-loaded modular configs:
  - `abbr.fish` - Abbreviations/aliases (loaded interactively)
  - `paths.fish` - XDG Base Directory paths
  - `exports.fish` - Environment variables
  - `fnm.fish` - FNM (Node) lazy-loaded on first use
  - `brew.fish` - Homebrew integration
  - `secrets.fish` - API keys (gitignored, create from `secrets.fish.example`)
- `functions/` - 26 custom functions
- `completions/` - Custom completions (voicemode, etc.)
- `themes/` - Color themes

**Important:** FNM and Zoxide use lazy-loading to optimize shell startup speed.

### Neovim Configuration (`neoed/.config/nvim/`)

**Framework:** LazyVim with extensive customizations (NEO.ED)

- `init.lua` - Bootstrap (loads `config.lazy`)
- `lua/config/lazy.lua` - Lazy.nvim package manager
- `lua/config/keymaps.lua` - Custom keybindings (matches Zed where possible)
- `lua/plugins/` - Plugin specifications:
  - `colorscheme.lua` - Theme config (Eldritch)
  - `lualine.lua` - Custom statusline
  - `snacks.lua` - UI enhancements
  - `supermaven.lua` - AI code completion
  - `themes/` - Color schemes (Eldritch, Neoed)
  - `languages/` - LSP configs per language
- `lazy-lock.json` - Dependency lock file

**Editor Priority:** Neovim is default git editor (`.gitconfig:3`)

### Git Configuration

**SSH Signing (not GPG):**

- Uses SSH keys for commit/tag signing
- Machine-specific config in `.gitconfig.local` (not tracked)
- Per-machine allowed signers file
- Setup script: `git/git.sh` provisions local config
- Delta pager for diff viewing

**Key Aliases:**

```bash
git cm "msg"    # Signed commit with message
git cma "msg"   # Add all + signed commit
git addi        # Interactive add with fzf selection
git logs        # Pretty graph log
git sm          # Submodule update --init --recursive
```

### Installation Scripts

**Flow:** `bootstrap.sh` -> `install.sh` -> individual scripts

1. **install.sh** - Main orchestrator:
   - Installs Xcode CLI tools, Homebrew, Git
   - Sources `scripts/functions.sh` for helpers
   - Runs `packages/packages.sh` for all package managers
   - Stows all packages
   - Runs `duti/duti.sh` (file associations)
   - Runs `macos/macos.sh` (system preferences)
   - Runs `git/git.sh` (git setup)

2. **packages/packages.sh** - Multi-package manager:
   - Homebrew (`Brewfile` - 80+ CLI tools, 50+ casks)
   - FNM (Node) - installs LTS + `node_packages.txt`
   - pipx (Python) - `pipx_packages.txt`
   - rbenv (Ruby) - `ruby_packages.txt`
   - rustup (Rust) - `rust_packages.txt`
   - Bun - `bun_packages.txt`

### Application Configs (`config/.config/`)

27+ applications configured:

- **Terminal:** alacritty, kitty, ghostty, wezterm
- **Multiplexers:** tmux, zellij
- **Window Manager:** aerospace (Stage Manager + Raycast)
- **File Manager:** yazi (custom keybindings)
- **Git UI:** lazygit
- **Monitoring:** btop, fastfetch
- **Launcher:** raycast (extensive scripts)
- **Prompt:** Oh My Posh (default) or Starship - configurable via `FISH_PROMPT` in `config.fish`
- **Updater:** topgrade (unified package updater)
- **Keyboard:** karabiner (Hyper key chording)
- **Editor:** zed (Vim mode + AI integration)

### Dependencies

Homebrew primary, FNM (Node), rbenv (Ruby), rustup (Rust), pipx (Python)

## Machine-Specific Configuration

- Use `.gitconfig.local` pattern (never commit machine-specific paths/keys)
- Per-machine files: `gitconfig-bigmac.local`, `gitconfig-macdaddy.local`
- After cloning on new machine, run `git/git.sh` to provision `.gitconfig.local`
- Secrets in `fish/.config/fish/conf.d/secrets.fish` (gitignored)

## Key Files

- `Makefile` - Primary interface for all dotfile operations
- `install.sh` - Main installation orchestrator
- `packages/Brewfile` - All Homebrew packages/casks/fonts
- `scripts/functions.sh` - Helper functions (error/success/info/warning with colors)
- `fish/.config/fish/conf.d/abbr.fish` - Shell aliases/abbreviations
- `git/.gitconfig` - Git aliases and configuration
- `neoed/.config/nvim/lua/config/keymaps.lua` - Neovim keybindings
- `config/.config/topgrade.toml` - Update manager config
- `.stow-local-ignore` - Files Stow should skip

## Development Patterns

### Adding New Configuration

1. Add files to appropriate stow package directory
2. Run `make stow pkg=<packagename>`
3. Test the configuration
4. Commit to git
5. Run `make update` to restow all packages

## Troubleshooting

**Stow Conflicts:**
```bash
make delete  # Remove all symlinks
make run     # Recreate all symlinks
```

**SSH Agent Issues:**
```bash
eva  # Alias for: eval ssh-agent -s; and ssh-add --apple-use-keychain
```

**FNM/Node Issues:**
```bash
fnm env --use-on-cd | source  # Enable auto-switching
npm install --global $(cat packages/node_packages.txt)
```

**Fisher Plugin Issues:**
```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

**Cargo/Rust Failures:**
```bash
brew uninstall rustup-init
brew reinstall rust
cargo install cargo-update --force
topgrade --only cargo
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

## Security Notes

- SSH signing enabled by default (commits & tags)
- GPG support available but SSH preferred
- Private directory (`private/`) intentionally empty for sensitive data
- SSH keys managed via macOS keychain
- Gatekeeper management in `macos/03-security.sh`
- LuLu firewall installed via Brewfile

## Version History

- **v3** (current) - Fish shell + GNU Stow
- **v2** - Fish shell + custom scripts
- **v1** - oh-my-zsh
