#!/usr/bin/env bash
set -eo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi

command -v duti >/dev/null 2>&1 || {
    error "duti is not installed"
    exit 1
}

info "Setting default applications using duti..."

find . -mindepth 1 -maxdepth 1 -type f ! -name 'duti.sh' ! -name '*.md' | while read -r fn; do
    bundle_id="${fn#./}"
    while read -r ext; do
        [ -n "$ext" ] || continue
        substep_info "Setting default application for extension $ext to $bundle_id..."
        duti -s "$bundle_id" "$ext" all || {
            substep_error "failed to set $ext to $bundle_id"
            exit 1
        }
    done <"$fn"
done

success "Successfully set all default applications."
