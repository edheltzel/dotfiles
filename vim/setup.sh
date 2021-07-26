#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.config/nvim)"

info "Setting up LunarCode..."

substep_info "Installing LunarCode..."
curl -sLf https://raw.githubusercontent.com/ChristianChiarulli/nvim/master/utils/install.sh | bash

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring LunarCode. Make sure you run :UpdateRemotePlugins to update plugins"
