#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
RAYCAST_PATH="$(realpath ~/.config/raycast)"

info "Setting up Raycast..."

substep_info "Creating Raycast folders..."
mkdir -p "$RAYCAST_PATH/raycats/_enable-commands"
mkdir -p "$RAYCAST_PATH/raycats/_enable-commands/images"

find * -name "*.sh" | while read fn; do
    symlink "$SOURCE/$fn" "$LOCAL_SHARE/$fn"
done
clear_broken_symlinks "$LOCAL_SHARE"

success "Finished setting up Raycast."
