#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"
VIM_DISTRO="LazyVim"

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

install_nvm() {
  nvm_repo='https://github.com/LazyVim/starter.git' # Corrected this line
  if [ -d "$NVM_DIR" ]; then                        # Already installed, update
    cd $NVM_DIR && git pull                         # Corrected this line
  else                                              # Not yet installed, prompt user to confirm before proceeding
    if read -p "$(echo -e "${YELLOW}Do you want to clone ${VIM_DISTRO}? (y/n): ${NC}")"; then
      echo -e "Installing..."
      cd $CONFIG_PATH && git clone $nvm_repo nvim
    else
      echo -e "Aborting..."
      return
    fi
  fi
}

# Call the install_nvm function
install_nvm

# delete the .git folder after install_nvm runs
rm -rf $NVM_DIR/.git

info "Setting symlinks for ${VIM_DISTRO}."
substep_success "nvim folder created."
success "Nvim with ${VIM_DISTRO} is ready. For more info: https://www.lazyvim.org/"
