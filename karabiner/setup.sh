#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
KARABINER_PATH="$(realpath ~/.config/karabiner)"

info "Setting up Karabiner..."

substep_info "Creating Karabiner folders..."
mkdir -p "$KARABINER_PATH/assets"
mkdir -p "$KARABINER_PATH/assets/complex_modifications"

find * -name "*json*" | while read fn; do
    symlink "$SOURCE/$fn" "$KARABINER_PATH/$fn"
done
clear_broken_symlinks "$KARABINER_PATH"

clear_broken_symlinks "$KARABINER_PATH"

success "Finished configuring Karabiner."
