# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -gx EDITOR code-insiders -w

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

# Volumes
set -gx VOL xxx
set -gx DROPBOX $HOME/Library/CloudStorage/Dropbox-RDM

# set XDG Base Directory Specification - there could be a better way to do this
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share

set -x XDG_DESKTOP_DIR $HOME/Desktop
set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -x XDG_DOCUMENTS_DIR $HOME/Documents
set -x XDG_MUSIC_DIR $HOME/Music
set -x XDG_PICTURES_DIR $HOME/Pictures
set -x XDG_VIDEOS_DIR $HOME/Videos
