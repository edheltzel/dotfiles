#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi

info "Setting default applications using duti..."

find . -mindepth 1 -maxdepth 1 -type f ! -name 'duti.sh' ! -name '*.md' | while read -r fn; do
    bundle_id="${fn#./}"
    while read -r ext; do
        [ -n "$ext" ] || continue
        substep_info "Setting default application for extension $ext to $bundle_id..."
        duti -s "$bundle_id" "$ext" all
    done <"$fn"
done

success "Successfully set all default applications."
