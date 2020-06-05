#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/karabiner)"

info "Setting up Karabiner..."

substep_info "Creating Karabiner folders..."
mkdir -p "$DESTINATION/assets"
mkdir -p "$DESTINATION/assets/complex_modifications"
mkdir -p "$DESTINATION/automatic_backups"

find * -name "*json*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

clear_broken_symlinks "$DESTINATION"

success "Finished configuring Karabiner."
