#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up neovim..."

substep_info "Creating nvim plug folder..."
mkdir -p "$DESTINATION/autoload"

find * -name "*vim*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished configuring neovim. Make sure you run :PlugInstall inside of nvim"
