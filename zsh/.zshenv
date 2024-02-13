# ~/.zshenv
# GlobalEnvironment variables

# XDG ZSH
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"

# Add variables for key Zsh directories.
export __zsh_config_dir=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}
export __zsh_user_data_dir=${XDG_DATA_HOME:-$HOME/.local/share}/zsh
export __zsh_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3f4964"
