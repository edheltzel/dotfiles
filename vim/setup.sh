#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.SpaceVim.d)"

info "Setting up SpaceVim..."

substep_info "Installing SpaceVime..."
curl -sLf https://spacevim.org/install.sh | bash

substep_info "Creating SpaceVim folders..."
mkdir -p "$DESTINATION/.SpaceVim.d"

find . -name ".SpaceVim.d" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring SpaceVim. Make sure you run :SPUpdate to update plugins and SpaceVim"
