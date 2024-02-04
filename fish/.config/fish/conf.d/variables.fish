# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -gx EDITOR code-insiders -w

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

# Volumes
set -gx VOL xxx
set -gx DROPBOX $HOME/Library/CloudStorage/Dropbox-RDM

# set XDG Base Directory Specification
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
