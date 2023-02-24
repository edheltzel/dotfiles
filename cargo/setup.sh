#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

substep_info "👀 Checking for FNM - Fast and simple NodeJS version manager..."
if test ! $(which fnm); then
    info "Installing FNM..."
    if /bin/bash -c "$(curl -fsSL https://fnm.vercel.app/install)"; then
        success "✅ FNM is now installed."
    else
        error "❌ Failed to install FNM."
    fi
else
    substep_success "👍 FNM - already installed."
fi


substep_info "Installing Node LTS set as default..."
fnm install --lts && fnm alias lts-latest default && fnm use default

substep_success "Finished installing Node with FNM."

packages=(
    "npm"
    "@antfu/ni"
    "@bitwarden/cli"
    "cspell"
    "easy-sharing"
    "generator-code"
    "netlify-cli"
    "vsce"
    "wrangler"
    "yo"
    "corepack"
)

for package in "${packages[@]}"; do
    substep_info "Installing $package..."
    npm install -g "$package"
    substep_success "✅ $package installed."
done
substep_info "Enabling Corepack..."
corepack enable
substep_success "✅ Corepack enabled."

success "✅ NodeJS setup complete."
