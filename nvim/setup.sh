#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up Neovim..."

substep_info "Fetching init.lua..."
wget https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua .

substep_info "Creating Neovim folders..."
mkdir -p $DESTINATION

find * -name "*.lua*" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done


clear_broken_symlinks "$DESTINATION"

success "Nvim is ready. Make sure to run :PackerInstall and then :PackerCompile"
