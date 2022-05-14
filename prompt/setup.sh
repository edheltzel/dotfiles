#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
CONFIG_PATH="$(realpath ~/.config)"

info "Setting up Starship prompt & Topgrade..."

find * -name "*.toml*" | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done

clear_broken_symlinks "$CONFIG_PATH"

success "Finished configuring Starship prompt & Topgrade."
