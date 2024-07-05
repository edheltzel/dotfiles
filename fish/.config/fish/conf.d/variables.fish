# set XDG Base Directory Specification - there could be a better way to do this
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_DESKTOP_DIR $HOME/Desktop
set -gx XDG_DOWNLOAD_DIR $HOME/Downloads
set -gx XDG_DOCUMENTS_DIR $HOME/Documents
set -gx XDG_MUSIC_DIR $HOME/Music
set -gx XDG_PICTURES_DIR $HOME/Pictures
set -gx XDG_VIDEOS_DIR $HOME/Videos

# cargo - IDK if this is necessary
set -gx CARGO_TARGET_DIR /var/folders/88/3h9cyc4979d2l6p7xkn79yqr0000gn/T/cargo-installx9AWBr

# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -gx EDITOR code

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

# Volumes
set -gx VOL xxx
# set -gx DROPBOX $HOME/Library/CloudStorage/Dropbox-RDM
