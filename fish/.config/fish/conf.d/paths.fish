# PATH configuration — single source of truth
# Uses fish_add_path (Fish 3.2+) — deduplicates automatically

# Homebrew env vars (from `brew shellenv`)
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
set -q MANPATH; or set MANPATH ''; set -gx MANPATH /opt/homebrew/share/man $MANPATH
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

# Core paths
fish_add_path $HOME/.local/bin
fish_add_path $HOMEBREW_PREFIX/bin
fish_add_path $HOMEBREW_PREFIX/sbin
fish_add_path /opt/homebrew/opt/openssl@1.1/bin
fish_add_path /opt/homebrew/opt/make/libexec/gnubin
fish_add_path $HOME/.gem/ruby/3.0.2/bin

# Rust (rustup.fish conf.d also adds this — fish_add_path deduplicates)
fish_add_path $HOME/.cargo/bin

# Go
set -gx GOPATH $HOME/.go
fish_add_path $GOPATH/bin

# Node/PNPM
set -gx PNPM_HOME $HOME/Library/pnpm
fish_add_path $PNPM_HOME

# Bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# Python
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# PHP
fish_add_path $HOME/.composer/vendor/bin

# Warp terminal
fish_add_path /Applications/Warp.app/Contents/MacOS

# Projects
set -gx PROJECTS_DIR $HOME/Developer

# FZF + FD
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# Netlify credential helper
test -f $HOME/Library/Preferences/netlify/helper/path.fish.inc
    and source $HOME/Library/Preferences/netlify/helper/path.fish.inc

# Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin
