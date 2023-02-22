#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    success "Finished installing XCode command line tools."
else
    error "Failed to install XCode command line tools."
fi

info "Checking for Homebrew..."
if test ! $(which brew); then
    info "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; then
        success "Finished installing Homebrew."
    else
        error "Failed to install Homebrew."
    fi
else
    success "Homebrew already installed."
fi

# Package control must be executed first in order for the rest to work
./packages/setup.sh # install homebrew and packages

find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
    ./$setup
done

success "Finished installing Dotfiles"
