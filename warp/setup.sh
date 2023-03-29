#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
WARP_PATH="$(realpath ~/.warp)"

info "Setting up Warp..."

substep_info "Creating Warp folder..."
mkdir -p $WARP_PATH

find * -name "*.yaml" | while read fn; do
    symlink "$SOURCE/$fn" "$WARP_PATH/$fn"
done

# Launch Configurations
find . -name "launch_configurations" | while read fn; do
    symlink "$SOURCE/$fn" "$WARP_PATH/$fn"
done

# Themes
find . -name "themes" | while read fn; do
    symlink "$SOURCE/$fn" "$WARP_PATH/$fn"
done

clear_broken_symlinks "$WARP_PATH"

success "Finished setting up Warp."
