#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh


sudo -v

packages=(
    "ccase"
    "ouch"
)

for package in "${packages[@]}"; do
    substep_info "Installing $package..."
    cargo install "$package"
    substep_success "✅ $package installed."
done
success "✅ Rust/Cargo setup complete."
