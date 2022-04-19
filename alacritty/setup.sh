#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
ALACRITTY_PATH="$(realpath ~/.config/alacritty)"

info "Setting up Alacritty..."

substep_info "Creating Alacritty folder..."
mkdir -p $ALACRITTY_PATH

find * -name "*.yml" | while read fn; do
    symlink "$SOURCE/$fn" "$ALACRITTY_PATH/$fn"
done
clear_broken_symlinks "$ALACRITTY_PATH"

success "Finished setting up Alacritty."
