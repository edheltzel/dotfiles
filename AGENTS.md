# agent guidelines - dotfiles repository

this file provides guidance to ai coding agents when working with code in this repository.

## repository overview

this is a fish shell-based macos dotfiles repository (v3) using **gnu stow** for symlink management. the repository follows a modular, package-based architecture where each major configuration area is a separate stow package.

**key philosophy:**

- non-invasive symlink-based configuration management
- xdg base directory compliance to keep `~` clean
- multi-editor strategy (neovim primary, zed secondary)
- performance-optimized shell with lazy-loading patterns
- machine-independent design with local overrides

## commands

### installation & setup

```bash
# fresh machine setup (runs install.sh)
make install

# symlink all dotfiles packages
make run

# add/remove individual packages
make stow pkg=nvim
make unstow pkg=nvim

# update all symlinked packages (restows + cleans dead symlinks)
make update  # or make up

# remove all symlinks
make delete
```

### testing & linting

- **test shell scripts**: run shellcheck manually, no automated tests
- **lint lua**: `stylua --check neoed/.config/nvim` (uses stylua.toml: 2 spaces, 120 width)

### package management

```bash
# update all packages and dependencies
upp  # alias for topgrade (updates homebrew, node, rust, etc.)

# package listing commands
brews          # list homebrew packages
casks          # list homebrew casks
npms           # list global npm packages
cargos         # list cargo packages
gems           # list ruby gems
```

### development workflow

```bash
# node version management (fnm)
fnm use                    # switch to .node-version or .nvmrc
fnm env --use-on-cd | source  # enable auto-switching

# git shortcuts (extensive aliases in .gitconfig)
git cm "message"           # signed commit
git cma "message"          # add all + signed commit
git addi                   # interactive add with fzf
git logs                   # pretty git log graph

# editors
nvim                       # primary editor (lazyvim-based neo.ed)
zed -n .                   # zed in new window (alias: zz)
code -r .                  # vscode reuse window (alias: coo)

# shell
reload                     # reload fish configuration
```

## code style

- **shell**: bash with `set -e`, use helper functions from `scripts/functions.sh` (error/success/info/warning), posix-compliant where possible
- **fish**: lazy-loading pattern for speed, functions in `functions/`, config in `conf.d/`, abbreviations not aliases
- **lua (neovim)**: 2 space indent, 120 char width, `set` for keymaps not `vim.keymap.set`, local vars, descriptive descriptions
- **formatting**: editorconfig enforced (2 spaces, lf, utf-8, trim=false, final newline), makefiles use tabs
- **comments**: use inline for complex logic, avoid obvious comments, document "why" not "what"

## architecture

### stow packages

the repository uses these stow packages (defined in `makefile:1`):

- **atlas** - personal ai infrastructure (pai) - **git submodule** ([repo](https://github.com/edheltzel/atlas))
  - claude code: hooks, skills, commands, voice system, observability dashboard
  - opencode: agents, commands, plugins, themes
  - symlinks to `~/.claude/` and `~/.config/opencode/`
- **dots** - misc dotfiles in `$home` (`.npmrc`, `.curlrc`, etc.)
- **git** - git configuration with ssh signing
- **fish** - fish shell config (xdg-compliant structure)
- **config** - 27+ application configs (yazi, raycast, aerospace, karabiner, zed, etc.)
- **neoed** - lazyvim customizations (neo.ed) - **git submodule** ([repo](https://github.com/edheltzel/neoed))
- **local** - user-specific non-config data

**git submodules:** both `atlas` and `neoed` are managed as separate repositories. after cloning, run `git submodule update --init --recursive` to initialize them.

### atlas - personal ai infrastructure

the `atlas/` submodule contains the personal ai infrastructure (pai) for claude code and opencode:

| directory | purpose |
|-----------|---------|
| `atlas/.claude/commands/atlas/` | 18 slash commands (`/atlas:*`) |
| `atlas/.claude/skills/` | 7 skills (core, art, agents, browser, prompting, etc.) |
| `atlas/.claude/hooks/` | typescript session lifecycle hooks |
| `atlas/.claude/voice/` | elevenlabs tts voice server |
| `atlas/.claude/observability/` | real-time vue dashboard |
| `atlas/.config/opencode/` | opencode ai configuration |

**working with atlas:**

```bash
# update atlas submodule
cd ~/.dotfiles/atlas && git pull origin master

# restow after changes
make stow pkg=atlas
```

**atlas commands:** run `/atlas:help` in claude code to see all available commands.

### xdg compliance

all paths configured in `fish/.config/fish/conf.d/paths.fish`:

- config: `~/.config`
- data: `~/.local/share`
- cache: `~/.cache`
- local: `~/.local`

### machine-specific configuration

- use `.gitconfig.local` pattern, never commit machine-specific paths/keys
- per-machine files: `gitconfig-bigmac.local`, `gitconfig-macdaddy.local`
- after cloning on new machine, run `git/git.sh` to provision `.gitconfig.local`

### dependencies

homebrew primary, fnm (node), rbenv (ruby), rustup (rust), pipx (python)

## conventions

- variables: `screaming_snake_case` for env/constants, `lowercase_snake` for locals in shell; `camelcase` in lua
- functions: `lowercase_snake_case` with verb prefixes (install*, check*, etc.)
- error handling: always use `set -e` in shell, validate commands exist before use, fail fast with clear messages

## code architecture

### fish shell structure (`fish/.config/fish/`)

**performance pattern:** minimal `config.fish` with lazy-loading

- `config.fish` - ultra-minimal for fast startup
- `conf.d/` - auto-loaded modular configs:
  - `abbr.fish` - abbreviations/aliases (loaded interactively)
  - `paths.fish` - xdg base directory paths
  - `exports.fish` - environment variables
  - `fnm.fish` - fnm (node) lazy-loaded on first use
  - `brew.fish` - homebrew integration
- `functions/` - 26 custom functions
- `completions/` - custom completions
- `themes/` - color themes

**important:** fnm and zoxide use lazy-loading to optimize shell startup speed.

### neovim configuration (`neoed/.config/nvim/`)

**framework:** lazyvim with extensive customizations (neo.ed)

- `init.lua` - bootstrap (loads `config.lazy`)
- `lua/config/lazy.lua` - lazy.nvim package manager
- `lua/config/keymaps.lua` - custom keybindings (matches zed where possible)
- `lua/plugins/` - plugin specifications:
  - `colorscheme.lua` - theme config (eldritch)
  - `lualine.lua` - custom statusline
  - `snacks.lua` - ui enhancements
  - `supermaven.lua` - ai code completion
  - `themes/` - color schemes (eldritch, neoed)
  - `languages/` - lsp configs per language
- `lazy-lock.json` - dependency lock file

**editor priority:** neovim is default git editor (`.gitconfig:3`)

### git configuration

**ssh signing (not gpg):**

- uses ssh keys for commit/tag signing
- machine-specific config in `.gitconfig.local` (not tracked)
- per-machine allowed signers file
- setup script: `git/git.sh` provisions local config

**key aliases:**

- `git cm "msg"` - signed commit with message
- `git cma "msg"` - add all + signed commit
- `git addi` - interactive add with fzf selection
- `git logs` - pretty graph log
- delta pager for diff viewing

### installation scripts

**flow:** `bootstrap.sh` → `install.sh` → individual scripts

1. **install.sh** - main orchestrator:
   - installs xcode cli tools, homebrew, git
   - sources `scripts/functions.sh` for helpers
   - runs `packages/packages.sh` for all package managers
   - stows all packages
   - runs `duti/duti.sh` (file associations)
   - runs `macos/macos.sh` (system preferences)
   - runs `git/git.sh` (git setup)

2. **packages/packages.sh** - multi-package manager:
   - homebrew (`brewfile` - 80+ cli tools, 50+ casks)
   - fnm (node) - installs lts + `node_packages.txt`
   - pipx (python) - `pipx_packages.txt`
   - rbenv (ruby) - `ruby_packages.txt`
   - rustup (rust) - `rust_packages.txt`
   - bun - `bun_packages.txt`

### application configs (`config/.config/`)

27+ applications configured:

- **terminal:** alacritty, kitty, ghostty, wezterm
- **multiplexers:** tmux, zellij
- **window manager:** aerospace (stage manager + raycast)
- **file manager:** yazi (custom keybindings)
- **git ui:** lazygit
- **monitoring:** btop, fastfetch
- **launcher:** raycast (extensive scripts)
- **prompt:** oh my posh (default) or starship - configurable via `fish_prompt` in `config.fish`
- **updater:** topgrade (unified package updater)
- **keyboard:** karabiner (hyper key chording)
- **editor:** zed (vim mode + ai integration)

## development patterns

### adding new configuration

1. add files to appropriate stow package directory
2. run `make stow pkg=<packagename>`
3. test the configuration
4. commit to git
5. run `make update` to restow all packages

### troubleshooting common issues

**ssh agent not persistent:**

```bash
eva  # alias for: eval ssh-agent -s; and ssh-add --apple-use-keychain
```

**node version issues:**

```bash
fnm env --use-on-cd | source  # enable auto-switching
npm install --global $(cat packages/node_packages.txt)
```

**fish plugin manager (fisher) issues:**

```bash
curl -sl https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

**cargo/rust update failures:**

```bash
brew uninstall rustup-init
brew reinstall rust
cargo install cargo-update --force
topgrade --only cargo
```

**stow conflicts:**

```bash
make delete  # remove all symlinks
make run     # recreate all symlinks
```

## key files

- `makefile` - primary interface for all dotfile operations
- `install.sh` - main installation orchestrator
- `packages/brewfile` - all homebrew packages/casks/fonts
- `fish/.config/fish/conf.d/abbr.fish` - shell aliases/abbreviations
- `git/.gitconfig` - git aliases and configuration
- `neoed/.config/nvim/lua/config/keymaps.lua` - neovim keybindings
- `config/.config/topgrade.toml` - update manager config
- `.stow-local-ignore` - files stow should skip

## security notes

- ssh signing enabled by default (commits & tags)
- gpg support available but ssh preferred
- private directory (`private/`) intentionally empty for sensitive data
- ssh keys managed via macos keychain
- gatekeeper management in `macos/03-security.sh`
- lulu firewall installed via brewfile

## version history

- **v3** (current) - fish shell + gnu stow
- **v2** - fish shell + custom scripts
- **v1** - oh-my-zsh
all agent guidelines have been consolidated into [claude.md](./claude.md).

please refer to `claude.md` for complete repository documentation including:
- repository overview and architecture
- commands and workflows
- code style and conventions
- stow package details
- troubleshooting guides
