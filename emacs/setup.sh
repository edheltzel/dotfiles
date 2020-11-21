#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.emacs.d)"

info "Setting up Emacs..."

substep_info "Creating Emacs folders..."
mkdir -p "$DESTINATION/.emacs.d"


find . -name ".emacs.d" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring Emacs."
