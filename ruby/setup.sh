#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

info "Installing rbenv - Ruby version manager..."
rbenv init

substep_info "Installing Ruby 3.1.3"
rbenv install 3.1.3
substep_success "Finished installing Ruby 3.1.3"

substep_info "Setting Ruby 3.1.3 as global"
rbenv global 3.1.3
rbenv rehash
substep_success "Finished Ruby setup"

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
