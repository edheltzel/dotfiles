# ~/.zshenv
# Environment variables

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"

# Apps
export BROWSER="brave"
export EDITOR="code-insiders"
export PAGER="most"
export TERMINAL="iterm"
export DROPBOX="${HOME}/Library/CloudStorage/Dropbox-RDM"
export VOL="xxx"

# Cargo
source "$HOME/.cargo/env"
. "$HOME/.cargo/env"

HISTSIZE=1000000
SAVEHIST=1000000
export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/.docker/bin":$PATH
export MANWIDTH=999
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.fnm:$PATH
