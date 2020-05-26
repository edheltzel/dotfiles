#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config)"

info "Setting up Alacritty..."

substep_info "Creating alacritty folders..."
mkdir -p "$DESTINATION/alacritty"

find . -name "*yml" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$DESTINATION"

success "Alacrity is now configured."
