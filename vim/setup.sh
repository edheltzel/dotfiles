#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.config/nvim)"

info "Setting up NVCode..."

substep_info "Installing NVCode..."
curl -sLf https://raw.githubusercontent.com/ChristianChiarulli/nvim/master/utils/install.sh | bash

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring NVCode. Make sure you run :UpdateRemotePlugins to update plugins"
