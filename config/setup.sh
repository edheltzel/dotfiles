#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIG_PATH="$(realpath ~/.config)"

info "Setting symlinks dotfiles and config folders."

substep_info "Symlink dotfiles to home directory..."
find . -maxdepth 1 -name ".*" -not -wholename ".DS_Store" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Successfully created symlinks."

substep_info "Symlinking ~/.config folders..."

# Starship prompt & Topgrade setup
find * -name "*.toml*" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Starship prompt & Topgrade are ready."

# bat setup
find . -name "bat" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Bat is ready."

# Raycast setup
find . -name "raycast" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Raycast is ready."

# iTerm setup
find . -name "iterm" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "iTerm is ready."

# Karabiner setup
find . -name "karabiner" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Karabiner is ready."

# VSCode setup
find . -name "vscode" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "VSCode is ready."

# Handy Shell utilitis for various day-to-day tasks
find . -name "utils" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Handy Shell utilitis are ready."

clear_broken_symlinks "$CONFIG_PATH"

success "Home Directory and Config folders configured."
