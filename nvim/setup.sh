#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
NVIM_PATH="$(realpath ~/.config/nvim)"

info "Setting up Neovim..."

substep_info "Creating Neovim folders..."
mkdir -p $NVIM_PATH
substep_success "Successfully created ~/.config/nvim/"

substep_info "Git is cloning AstroVim..."

git --progress -C "$NVIM_PATH" remote set-url origin https://github.com/AstroNvim/AstroNvim.git

substep_success "Successfully cloned AstroVim"

info "Initializing AstroNvim"
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

success "Nvim is ready."
