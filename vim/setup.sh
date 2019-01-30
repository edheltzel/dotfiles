#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
LOCAL="$(realpath ~/.local/share/nvim/site)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up neovim..."

substep_info "Creating nvim plug folder..."
mkdir -p "$LOCAL/autoload"

find * -name "*vim*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished configuring neovim. Make sure you run :PlugInstall inside of nvim"
