#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh


sudo -v

packages=(
    "pep8"
    "pylint"
    "pygments"
    "--upgrade neovim"
)

for package in "${packages[@]}"; do
    substep_info "Installing $package..."
    pip3 install "$package"
    substep_success "✅ $package installed."
done
success "✅ Python/Pip setup complete."
