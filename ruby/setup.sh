#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

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

packages=(
    "bundle"
    "jekyll"
    "neovim"
)

for package in "${packages[@]}"; do
    substep_info "Installing $package..."
    gem install "$package"
    substep_success "✅ $package installed."
done
success "✅ Rust/Cargo setup complete."
