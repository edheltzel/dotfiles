#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.config/nvim)"

info "Setting up LunarVim..."

substep_info "Installing LunarVim..."
bash (curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | psub)

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring LunarVim. `vim` is an alias if `lvim`"
