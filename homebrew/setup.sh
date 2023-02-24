#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

# COMMENT=\#*

sudo -v

info "Checking for Brewfile..."
if ! $(brew bundle check); then
    info "Brewfile found..."
    if /bin/bash -c "$(brew bundle install)"; then
        success "✅ Brewfile is now installed."
    else
        error "❌ Failed to install Brewfile."
    fi
else
    substep_success "👍 Brewfile - already installed."
fi


# brew bundle
# success "Finished installing Brewfile packages."
# find * -name "*.list" | while read fn; do
#     cmd="${fn%.*}"
#     set -- $cmd
#     info "Installing $1 packages..."
#     while read package; do
#         if [[ $package == $COMMENT ]];
#         then continue
#         fi
#         substep_info "Installing $package..."
#         if [[ $cmd == code* ]]; then
#             $cmd $package
#         else
#             $cmd install $package
#         fi
#     done < "$fn"
#     success "Finished installing $1 packages."
# done
