#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.local/share)"

info "Setting up Raycast..."

substep_info "Creating Raycast folders..."
mkdir -p "$DESTINATION/raycast"
mkdir -p "$DESTINATION/raycats/_enable-commands"
mkdir -p "$DESTINATION/raycats/_enable-commands/images"

find * -name "*.sh" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished setting up Raycas."
