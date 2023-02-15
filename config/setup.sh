#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIG_PATH="$(realpath ~/.config)"
NVM_DIR="$(realpath ~/.config/nvim)"

install_nvm () {
  nvm_repo='https://github.com/AstroNvim/AstroNvim.git'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull
  else # Not yet installed, promt user to confirm before proceeding
    if read -p "\nInstall AstroNvim now? (y/N)"; then
      echo -e "\nInstalling..."
      git clone $nvm_repo $NVM_DIR
    else
      echo -e "\nAborting..."
      return
    fi
  fi
}

info "Setting symlinks dotfiles and config folders."

substep_info "Symlink dotfiles to home directory..."
find * -name ".*" -not -wholename "*DS_Store*" -not -wholename "*gitkeep*" | while read fn; do
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

#NeoVim AstroVim setup
substep_info "Installing AstroVim..."
install_nvm
substep_success "Nvim is ready. Make sure to run :PackerSync to install plugins."

clear_broken_symlinks "$CONFIG_PATH"

success "Home Directory and Config folders configured."

