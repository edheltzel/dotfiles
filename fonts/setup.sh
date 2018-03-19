#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/Library/Fonts)"

info "Setting up fonts..."

find * -name "*.otf" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
