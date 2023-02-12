#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages."

info "Installing FNM - Fast and simple NodeJS version manager..."
curl -fsSL https://fnm.vercel.app/install | bash

substep_info "Installing Node LTS with Corepack enabled"
fnm install --lts && npm i -g corepack && corepack enable

success "Finished installing Node with FNM."

find * -name "*.list" | while read fn; do
    cmd="${fn%.*}"
    set -- $cmd
    info "Installing $1 packages..."
    while read package; do
        if [[ $package == $COMMENT ]];
        then continue
        fi
        substep_info "Installing $package..."
        if [[ $cmd == code* ]]; then
            $cmd $package
        else
            $cmd install $package
        fi
    done < "$fn"
    success "Finished installing $1 packages."
done
