#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"

install_nvm () {
  nvm_repo='https://github.com/ecosse3/nvim.git'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull ./
  else # Not yet installed, promt user to confirm before proceeding
    if read -p "$(echo -e '${YELLOW}Do you want to clone Ecovim? (y/n): ${NC}')"; then
      -e "Installing..."
      cd $CONFIG_PATH && git clone $nvm_repo nvim
    else
      echo -e "Aborting..."
      return
    fi
  fi
}

info "Setting symlinks for NeoVim."
#NeoVim Ecoim setup
substep_success "nvim folder created."
# substep_info "Installing Ecovim..."
install_nvm
success "Nvim is ready."



