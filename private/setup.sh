#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath ~/RDM\ Dropbox/Ed\ Heltzel/Apps/DotFiles)"
DESTINATION="$(realpath ~)"

info "Configuring Secrets..."
substep_info "Symlink ssh to home directory..."
find . -name "ssh" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/.$fn"
done
success "Finished configuring Secrets."
