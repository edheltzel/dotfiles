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
    printf "${YELLOW}Do you want to clone %s? (y/N): ${NC}" "$VIM_DISTRO"
    read -r reply
    case "$reply" in
      [yY]|[yY][eE][sS])
        echo "Installing..."
        cd "$CONFIG_PATH" && git clone "$nvm_repo" nvim
        ;;
      *)
        echo "Aborting..."
        return
        ;;
    esac
  fi
}

# Call the install_nvm function
install_nvm

# delete the .git folder after install_nvm runs
rm -rf $NVM_DIR/.git

info "Setting symlinks for ${VIM_DISTRO}."
substep_success "nvim folder created."
success "Nvim with ${VIM_DISTRO} is ready. For more info: https://www.lazyvim.org/"
