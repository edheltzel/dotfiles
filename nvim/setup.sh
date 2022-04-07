#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up Neovim..."

substep_info "Creating Neovim folders..."
mkdir -p $DESTINATION
substep_success "Successfully created ~/.config/nvim/"

substep_info "Git is cloning AstroVim..."
git clone --progress --verbose https://github.com/kabinspace/AstroVim "$DESTINATION/."
substep_success "Successfully cloned AstroVim"

success "Nvim is ready. Make sure to run – nvim +PackerSync"
