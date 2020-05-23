#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up neovim..."

substep_info "Creating nvim folders..."
mkdir -p "$DESTINATION/autoload"
mkdir -p "$DESTINATION/configs"
mkdir -p "$DESTINATION/general"
mkdir -p "$DESTINATION/keys"
mkdir -p "$DESTINATION/lua"
mkdir -p "$DESTINATION/plugs"
mkdir -p "$DESTINATION/themes"
mkdir -p "$DESTINATION/utils"
mkdir -p "$DESTINATION/vscode"

find * -type f \( -iname \*vim* -o -iname \*lua* \)  | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$DESTINATION"

success "Finished configuring Neovim. Make sure you run :PlugInstall inside of nvim"
