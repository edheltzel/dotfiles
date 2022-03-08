#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up Neovim..."

substep_info "Creating Neovim folders..."
mkdir -p $DESTINATION
mkdir -p "$DESTINATION/after/ftplugin"
mkdir -p "$DESTINATION/lua/"
mkdir -p "$DESTINATION/lua/config"
mkdir -p "$DESTINATION/snippets"

find * -name "*.*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished setting up Neovim."
