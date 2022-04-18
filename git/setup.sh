#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring git..."

find . -name ".git*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

substep_info "Setting up and creating gh directory at '$DESTINATION'/gh"

mkdir -p "$DESTINATION/gh"

find * -name "*.yml*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

clear_broken_symlinks "$DESTINATION"

success "Finished configuring git and gh. Make sure to copy hosts.yml from secrets"
