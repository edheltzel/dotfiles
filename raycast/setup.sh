#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
LOCAL_SHARE="$(realpath ~/.local/share)"

info "Setting up Raycast..."

substep_info "Creating Raycast folders..."
mkdir -p "$LOCAL_SHARE/raycast"
mkdir -p "$LOCAL_SHARE/raycats/_enable-commands"
mkdir -p "$LOCAL_SHARE/raycats/_enable-commands/images"

find * -name "*.sh" | while read fn; do
    symlink "$SOURCE/$fn" "$LOCAL_SHARE/$fn"
done
clear_broken_symlinks "$LOCAL_SHARE"

success "Finished setting up Raycast."
