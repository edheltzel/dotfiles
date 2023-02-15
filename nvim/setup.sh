#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"

install_nvm () {
  nvm_repo='https://github.com/AstroNvim/AstroNvim.git'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull ./
  else # Not yet installed, promt user to confirm before proceeding
    if read -p "Install AstroNvim now? (y/N)"; then
      echo -e "Installing..."
      cd $CONFIG_PATH && git clone $nvm_repo nvim
    else
      echo -e "Aborting..."
      return
    fi
  fi
}

info "Setting symlinks for NeoVim."
#NeoVim AstroVim setup
substep_success "nvim folder created."
# substep_info "Installing AstroVim..."
install_nvm
substep_success "Nvim is ready. Make sure to run :PackerSync to install plugins."


success "Home Directory and Config folders configured."

