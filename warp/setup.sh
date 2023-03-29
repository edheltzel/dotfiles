#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up Warp..."

substep_info "Creating Warp folder..."
mkdir -p $DESTINATION/.warp

find * -name "*.yaml" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# Launch Configurations
find . -name "launch_configurations" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# Themes
find . -name "themes" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$DESTINATION"

success "Finished setting up Warp."
