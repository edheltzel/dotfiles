# ~/.zshenv
setopt autocd            # Change to directory without cd
setopt correctall        # Auto correct commands
setopt extendedglob      # Enable extended globbing
setopt hist_ignore_dups  # Ignore duplicate commands
setopt hist_ignore_space # Ignore commands starting with space

# XDG ZSH
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"

# Apps and Volumes
# export BROWSER="brave browser"
export EDITOR="code-insiders"
export PAGER="most"
export TERMINAL="iterm"
# export DROPBOX="${HOME}/Library/CloudStorage/Dropbox-RDM"
export VOL="xxx"

# Cargo
source "$HOME/.cargo/env"
. "$HOME/.cargo/env"

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=100000

export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/.docker/bin":$PATH
export MANWIDTH=999
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.fnm:$PATH

# Ruby
# export PATH="$HOME/.rbenv/bin:$PATH"
