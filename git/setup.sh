#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
GIT_PATH="$(realpath ~)"
GH_PATH="$(realpath ~/.config/gh)"

info "Configuring git..."

find . -name ".git*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$GIT_PATH/$fn"
done

substep_info "Setting up gh..."
find * -name "*.yml*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$GH_PATH/$fn"
done
clear_broken_symlinks "$GH_PATH"

success "git and gh are complete. Make sure to copy hosts.yml from secrets"
