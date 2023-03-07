#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting symlinks for Git."

find . -maxdepth 1 -name ".*" -not -wholename "*DS_Store*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Successfully created symlinks."

clear_broken_symlinks

substep_success "Setting up Local Git Config for MacDaddy and BigMac"
localgitconfig

success "Git configured for $(hostname)"
