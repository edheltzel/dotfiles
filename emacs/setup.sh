#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up Emacs..."

substep_info "Cloning and Installing Spacemacs..."
git clone https://github.com/syl20bnr/spacemacs "$DESTINATION/.emacs.d"

find . -name ".spacemacs" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$CONFIGDEST"

success "Finished configuring Emacs."
