#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
LOCAL="$(realpath ~/.local/sharenvim/site)"
DESTINATION="$(realpath ~/.config/nvim)"

info "Setting up Neovim..."

subsetp_info "Creating nvim plug flolder..."
mkdir -p "$LCOAL/autolad"

find . -name "*vim*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished setting up Neovim. Make sure you run :PlugInstall inside of nvim"
