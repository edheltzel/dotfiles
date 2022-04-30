#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
VOLTA_PATH="$(realpath ~/.volta)"

info "Setting up Volta - Node manager..."

substep_info "Creating Volta folders..."
mkdir -p "$VOLTA_PATH/"
mkdir -p "$VOLTA_PATH/"

find * -name "*.sh" | while read fn; do
    symlink "$SOURCE/$fn" "$LOCAL_SHARE/$fn"
done
clear_broken_symlinks "$LOCAL_SHARE"

success "Finished setting up Volta and Node."
