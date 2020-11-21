#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.SpaceVim)"
CONFIGDEST2="$(realpath ~/.SpaceVim.d)"

info "Setting up SpaceVim..."

substep_info "Creating SpaceVim folders..."
mkdir -p "$DESTINATION/.SpaceVim"
mkdir -p "$DESTINATION/.SpaceVim.d"


find . -name ".SpaceVim" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

find . -name ".SpaceVim.d" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$CONFIGDEST"
clear_broken_symlinks "$CONFIGDEST2"

success "Finished configuring SpaceVim. Make sure you run :SPUpdate to update plugins and SpaceVim"
