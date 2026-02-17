# Environment variables — single source of truth
# Non-interactive vars (needed by scripts, git, cron) come FIRST, outside guard
# Interactive-only setup (aliases, keybindings) inside guard

# XDG Base Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_DESKTOP_DIR $HOME/Desktop
set -gx XDG_DOWNLOAD_DIR $HOME/Downloads
set -gx XDG_DOCUMENTS_DIR $HOME/Documents
set -gx XDG_MUSIC_DIR $HOME/Music
set -gx XDG_PICTURES_DIR $HOME/Pictures
set -gx XDG_VIDEOS_DIR $HOME/Videos

# Tools
set -gx EZA_CONFIG_DIR $HOME/.config/eza
set -gx EZA_COLORS "gm=33;1"
set -gx MANPAGER "nvim +Man!"
set -gx TERMINAL wezterm
set -gx EDITOR zed
set -gx LC_ALL en_US.UTF-8

# Nvim shell integration (terminal-aware)
string match -q "$TERM_PROGRAM" nvim
    and . (nvim --locate-shell-integration-path fish)

# Interactive-only: key bindings, aliases
if status is-interactive
    set -g fish_key_bindings fish_default_key_bindings

    source ~/.config/fish/functions/_aliases.fish
end
