#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi

info "Setting default applications using duti..."

find . -mindepth 1 -maxdepth 1 -not -name "duti.sh" -type f | while read -r fn; do
    while read ext; do
        substep_info "Setting default application for extension $ext to $fn..."
        duti -s $fn $ext all
    done <$fn
done

success "Successfully set all default applications."
