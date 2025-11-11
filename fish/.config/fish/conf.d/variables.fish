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

set -gx EZA_CONFIG_DIR $HOME/.config/eza

# cargo
set -gx CARGO_TARGET_DIR /var/folders/88/3h9cyc4979d2l6p7xkn79yqr0000gn/T/cargo-installx9AWBr

# Open MAN pages in Neovim
set -gx MANPAGER "nvim +Man!"

# Default Terminal use kitty, warp, wezterm, ghostty, etc.
set -gx TERMINAL kitty
set -gx WARP_THEME_DIR "$HOME/.warp/themes"

string match -q "$TERM_PROGRAM" nvim
and . (nvim --locate-shell-integration-path fish)

# Default Editor use zed, code, nvim, etc.
set -gx EDITOR zed

# Volumes
set -gx VOL xxx
# set -gx DROPBOX $HOME/Library/CloudStorage/Dropbox-RDM
