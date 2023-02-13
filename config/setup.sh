#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"


info "Setting symlinks dotfiles and config folders."

substep_info "Symlink dotfiles to home directory..."
find . -name ".*" -not -wholename "*DS_Store*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Successfully created symlinks."

substep_info "Symlinking ~/.config folders..."

#Starship prompt & Topgrade setup
find * -name "*.toml*" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Starship prompt & Topgrade are ready."

#bat setup
find . -name "bat" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Bat is ready."

#Raycast setup
find . -name "raycast" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Raycast is ready."

#iTerm setup
find . -name "iterm" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "iTerm is ready."

#Karabiner setup
find . -name "karabiner" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Karabiner is ready."

#VSCode setup
find . -name "vscode" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "VSCode is ready."

# Handy Shell utilitis for various day-to-day tasks
find . -name "utils" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "Handy Shell utilitis are ready."

#Github GH setup
find . -name "gh" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done
substep_success "GH is ready. Make sure to copy hosts.yml from secrets folder to ~/.config/gh/hosts.yml"




#NeoVim AstroVim setup
# substep_info "Git is cloning AstroVim..."
# mkdir -p $NVM_DIR
# git --progress -C "$NVM_DIR" remote set-url origin https://github.com/AstroNvim/AstroNvim.git

# substep_success "Successfully cloned AstroVim"

# substep_info "Initializing AstroNvim"
# nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# substep_success "Nvim is ready."

# Helper function to install NVM
install_nvm () {
  nvm_repo='https://github.com/AstroNvim/AstroNvim.git'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull
  else # Not yet installed, promt user to confirm before proceeding
    if read -q "choice?Install AstroNvim now? (y/N)"; then
      echo -e "\nInstalling..."
      git clone $nvm_repo $NVM_DIR
    else
      echo -e "\nAborting..."
      return
    fi
  fi
}

install_nvm
# substep_success "Nvim is ready. Make sure to run :PackerSync to install plugins."

clear_broken_symlinks "$CONFIG_PATH"

success "Home Directory and Config folders configured."

