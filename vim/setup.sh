#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up neovim..."

substep_info "Creating nvim autoload folder..."
mkdir -p "$DESTINATION/autoload"
mkdir -p "$DESTINATION/general"
mkdir -p "$DESTINATION/keys"
mkdir -p "$DESTINATION/plugs"

find * -name "*vim*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished configuring Neovim. Make sure you run :PlugInstall inside of nvim"
