# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Coding Guidelines

**For build commands, code style, conventions, and development standards, see [AGENTS.md](AGENTS.md).**

## Repository Overview

This is a Fish shell-based macOS dotfiles repository (v3) using **GNU Stow** for symlink management. The repository follows a modular, package-based architecture where each major configuration area is a separate stow package.

**Key Philosophy:**

- Non-invasive symlink-based configuration management
- XDG Base Directory compliance to keep `~` clean
- Multi-editor strategy (Neovim primary, Zed secondary, VSCode tertiary)
- Performance-optimized shell with lazy-loading patterns
- Machine-independent design with local overrides

## Essential Commands

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

## Stow Packages Architecture

The repository uses these stow packages (defined in `Makefile:1`):

- **dots** - Misc dotfiles in `$HOME` (`.npmrc`, `.curlrc`, etc.)
- **git** - Git configuration with SSH signing
- **fish** - Fish shell config (XDG-compliant structure)
- **config** - 27+ application configs (yazi, raycast, aerospace, etc.)
- **karabiner** - Complex keyboard customization (Hyper key chording)
- **nvim** - LazyVim customizations (NEO.ED)
- **vscode** - VSCode settings, keybindings, custom CSS
- **zed** - Zed editor config with Vim mode + AI integration
- **local** - User-specific non-config data

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

27 applications configured:

- **Terminal:** alacritty, kitty, ghostty, wezterm
- **Multiplexers:** tmux, zellij
- **Window Manager:** aerospace (Stage Manager + Raycast)
- **File Manager:** yazi (custom keybindings)
- **Git UI:** lazygit
- **Monitoring:** btop, fastfetch
- **Launcher:** raycast (extensive scripts)
- **Prompt:** Oh My Posh (default) or Starship - configurable via `FISH_PROMPT` in `config.fish`
- **Updater:** topgrade (unified package updater)

## Important Development Patterns

### Machine-Specific Configuration

Git config includes machine-specific overrides:

```bash
# .gitconfig includes .gitconfig.local (not tracked)
# Per-machine files: gitconfig-bigmac.local, gitconfig-macdaddy.local
```

After cloning on new machine, run `git/git.sh` to provision `.gitconfig.local`.

### XDG Base Directory Compliance

All paths configured in `fish/.config/fish/conf.d/paths.fish`:

- Config: `~/.config/`
- Data: `~/.local/share/`
- Cache: `~/.cache/`
- Local: `~/.local/`

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

## Key Files to Know

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

## Current State (Git Status)

Multiple staged deletions from old nvim.exosyphon config cleanup. Modified files show recent work on:

- Neovim config updates (keymaps, lazy.lua, colorscheme)
- Lualine theme customization
- Snacks.lua reorganization
- New Eldritch theme integration
