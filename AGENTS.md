# Agent Guidelines - Dotfiles Repository

This file provides guidance to AI coding agents when working with code in this repository.

## Repository Overview

This is a Fish shell-based macOS dotfiles repository (v3) using **GNU Stow** for symlink management. The repository follows a modular, package-based architecture where each major configuration area is a separate stow package.

**Key Philosophy:**

- Non-invasive symlink-based configuration management
- XDG Base Directory compliance to keep `~` clean
- Multi-editor strategy (Neovim primary, Zed secondary)
- Performance-optimized shell with lazy-loading patterns
- Machine-independent design with local overrides

## Commands

### Installation & Setup

```bash
# Fresh machine setup (runs install.sh)
make install

# Symlink all dotfiles packages
make run

# Add/remove individual packages
make stow pkg=nvim
make unstow pkg=nvim

# Update all symlinked packages (restows + cleans dead symlinks)
make update  # or make up

# Remove all symlinks
make delete
```

### Testing & Linting

- **Test shell scripts**: Run shellcheck manually, no automated tests
- **Lint Lua**: `stylua --check neoed/.config/nvim` (uses stylua.toml: 2 spaces, 120 width)

### Package Management

```bash
# Update ALL packages and dependencies
upp  # alias for topgrade (updates Homebrew, Node, Rust, etc.)

# Package listing commands
brews          # List Homebrew packages
casks          # List Homebrew casks
npms           # List global npm packages
cargos         # List Cargo packages
gems           # List Ruby gems
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

# Editors
nvim                       # Primary editor (LazyVim-based NEO.ED)
zed -n .                   # Zed in new window (alias: zz)
code -r .                  # VSCode reuse window (alias: coo)

# Shell
reload                     # Reload Fish configuration
```

## Code Style

- **Shell**: Bash with `set -e`, use helper functions from `scripts/functions.sh` (error/success/info/warning), POSIX-compliant where possible
- **Fish**: Lazy-loading pattern for speed, functions in `functions/`, config in `conf.d/`, abbreviations not aliases
- **Lua (Neovim)**: 2 space indent, 120 char width, `set` for keymaps not `vim.keymap.set`, local vars, descriptive descriptions
- **Formatting**: EditorConfig enforced (2 spaces, LF, UTF-8, trim=false, final newline), Makefiles use tabs
- **Comments**: Use inline for complex logic, avoid obvious comments, document "why" not "what"

## Architecture

### Stow Packages

The repository uses these stow packages (defined in `Makefile:1`):

- **atlas** - Personal AI Infrastructure (PAI) - **Git Submodule** ([repo](https://github.com/edheltzel/atlas))
  - Claude Code: hooks, skills, commands, voice system, observability dashboard
  - OpenCode: agents, commands, plugins, themes
  - Symlinks to `~/.claude/` and `~/.config/opencode/`
- **dots** - Misc dotfiles in `$HOME` (`.npmrc`, `.curlrc`, etc.)
- **git** - Git configuration with SSH signing
- **fish** - Fish shell config (XDG-compliant structure)
- **config** - 27+ application configs (yazi, raycast, aerospace, karabiner, zed, etc.)
- **neoed** - LazyVim customizations (NEO.ED) - **Git Submodule** ([repo](https://github.com/edheltzel/neoed))
- **local** - User-specific non-config data

**Git Submodules:** Both `atlas` and `neoed` are managed as separate repositories. After cloning, run `git submodule update --init --recursive` to initialize them.

### XDG Compliance

All paths configured in `fish/.config/fish/conf.d/paths.fish`:

- Config: `~/.config`
- Data: `~/.local/share`
- Cache: `~/.cache`
- Local: `~/.local`

### Machine-Specific Configuration

- Use `.gitconfig.local` pattern, never commit machine-specific paths/keys
- Per-machine files: `gitconfig-bigmac.local`, `gitconfig-macdaddy.local`
- After cloning on new machine, run `git/git.sh` to provision `.gitconfig.local`

### Dependencies

Homebrew primary, FNM (Node), rbenv (Ruby), rustup (Rust), pipx (Python)

## Conventions

- Variables: `SCREAMING_SNAKE_CASE` for env/constants, `lowercase_snake` for locals in shell; `camelCase` in Lua
- Functions: `lowercase_snake_case` with verb prefixes (install*, check*, etc.)
- Error handling: Always use `set -e` in shell, validate commands exist before use, fail fast with clear messages

## Code Architecture

### Fish Shell Structure (`fish/.config/fish/`)

**Performance Pattern:** Minimal `config.fish` with lazy-loading

- `config.fish` - Ultra-minimal for fast startup
- `conf.d/` - Auto-loaded modular configs:
  - `abbr.fish` - Abbreviations/aliases (loaded interactively)
  - `paths.fish` - XDG Base Directory paths
  - `exports.fish` - Environment variables
  - `fnm.fish` - FNM (Node) lazy-loaded on first use
  - `brew.fish` - Homebrew integration
- `functions/` - 26 custom functions
- `completions/` - Custom completions
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

**Key Aliases:**

- `git cm "msg"` - Signed commit with message
- `git cma "msg"` - Add all + signed commit
- `git addi` - Interactive add with fzf selection
- `git logs` - Pretty graph log
- Delta pager for diff viewing

### Installation Scripts

**Flow:** `bootstrap.sh` → `install.sh` → individual scripts

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

## Development Patterns

### Adding New Configuration

1. Add files to appropriate stow package directory
2. Run `make stow pkg=<packagename>`
3. Test the configuration
4. Commit to git
5. Run `make update` to restow all packages

### Troubleshooting Common Issues

**SSH Agent Not Persistent:**

```bash
eva  # Alias for: eval ssh-agent -s; and ssh-add --apple-use-keychain
```

**Node Version Issues:**

```bash
fnm env --use-on-cd | source  # Enable auto-switching
npm install --global $(cat packages/node_packages.txt)
```

**Fish Plugin Manager (Fisher) Issues:**

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

**Cargo/Rust Update Failures:**

```bash
brew uninstall rustup-init
brew reinstall rust
cargo install cargo-update --force
topgrade --only cargo
```

**Stow Conflicts:**

```bash
make delete  # Remove all symlinks
make run     # Recreate all symlinks
```

## Key Files

- `Makefile` - Primary interface for all dotfile operations
- `install.sh` - Main installation orchestrator
- `packages/Brewfile` - All Homebrew packages/casks/fonts
- `fish/.config/fish/conf.d/abbr.fish` - Shell aliases/abbreviations
- `git/.gitconfig` - Git aliases and configuration
- `neoed/.config/nvim/lua/config/keymaps.lua` - Neovim keybindings
- `config/.config/topgrade.toml` - Update manager config
- `.stow-local-ignore` - Files Stow should skip

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
