#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuraing misc dots..."

find . -name ".*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished configuring misc dotfiles."
