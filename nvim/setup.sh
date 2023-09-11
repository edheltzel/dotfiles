#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"
VIM_DISTRO="LazyVim"

install_nvm() {
  nvm_repo='git clone https://github.com/LazyVim/starter'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull ./
  else # Not yet installed, promt user to confirm before proceeding
    if read -p "$(echo -e '${YELLOW}Do you want to clone ${VIM_DISTRO}? (y/n): ${NC}')"; then
      -e "Installing..."
      cd $CONFIG_PATH && git clone $nvm_repo nvim
    else
      echo -e "Aborting..."
      return
    fi
  fi
}

info "Setting symlinks for ${VIM_DISTRO}."
substep_success "nvim folder created."
success "Nvim with ${VIM_DISTRO} is ready."
