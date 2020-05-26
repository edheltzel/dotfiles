#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/alacritty)"

info "Setting up Alacritty..."

substep_info "Creating Alacritty folder..."
mkdir -p $DESTINATION

find * -name "*.yml" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished setting up Alacritty."
