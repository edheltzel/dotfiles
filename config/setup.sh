#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIG_PATH="$(realpath ~/.config)"

info "Configuring ~/.config and home dotfiles"

find . -name ".*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

find . -name "bat" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done

find . -name "raycast" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$CONFIG_PATH/$fn"
done

success "Finished setting up .config "
