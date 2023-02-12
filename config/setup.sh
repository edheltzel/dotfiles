#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIG_PATH="$(realpath ~/.config)"

info "Setting symlinks dotfiles and config folders."

substep_info "Symlink dotfiles to home directory..."
find . -name ".*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Successfully created symlinks."

substep_info "Symlinking ~/.config folders..."
find . -name "bat" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Bat is ready."

find . -name "raycast" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Raycast is ready."

find . -name "iterm" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "iTerm is ready."

find . -name "karabiner" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Karabiner is ready."

find * -name "*.toml*" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Starship prompt & Topgrade are ready."

clear_broken_symlinks "$CONFIG_PATH"

success "Finished setting up ~/.config"
