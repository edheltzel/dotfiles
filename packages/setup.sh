#!/usr/bin/env bash
sudo -v

# Define variables for each package manager and include the corresponding package lists
. ../scripts/functions.sh
brew_packages="Brewfile"
node_packages="node_packages.txt"
bun_packages="bun_packages.txt"
python_packages="python_packages.txt"
ruby_packages="ruby_packages.txt"
rust_packages="rust_packages.txt"

# Define a function for installing packages with Homebrew
install_brew_packages() {
    if ! command -v $(which brew) &>/dev/null; then
        substep_info "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if ! command -v $(which brew) &>/dev/null; then
            error "Failed to install Homebrew. Exiting."
            exit 1
        fi
        substep_success "Homebrew installed."
    fi
    info "Installing Homebrew packages..."
    brew update
    brew upgrade
    brew bundle --file="$brew_packages"
    success "Finished installing Homebrew packages."
}

# Install Node with FNM and set latest LTS as default, then install npm packages
install_node_packages() {
    # Install FNM
    if ! command -v fnm &>/dev/null; then
        substep_info "Installing FNM..."
        curl -fsSL https://fnm.vercel.app/install | bash
        eval "$(fnm env --use-on-cd)" # needed to install npm packages - already set for Fish
        substep_success "FNM installed."
    fi

    # Install latest LTS version of Node with FNM and set as default
    if ! fnm use --lts &>/dev/null; then
        info "Installing latest LTS version of Node..."
        fnm install --lts
        fnm alias lts-latest default
        fnm use default
        substep_success "Node LTS installed and set as default for FNM."
    fi

    # Install NPM packages
    info "Installing NPM packages..."
    npm install -g $(cat $node_packages)
    corepack enable
    success "All NPM global packages installed."

    # Install Bun packages - using Bun as global package manager
    info "Installing Bun packages..."
    pnpm add -g $(cat $bun_packages)
    success "All Bun global packages installed."
}

# Define a function for installing packages with Python
install_python_packages() {
    if ! command -v $(which python) &>/dev/null; then
        substep_info "Python not found. Installing..."
        brew install python
        if ! command -v $(which python) &>/dev/null; then
            error "Failed to install Python. Exiting."
            exit 1
        fi
        substep_success "Python installed."
    fi
    info "Installing Python packages..."
    pip install $(cat "$python_packages")
    success "Finished installing Python packages."
}

# Install Ruby with rbenv, set 3.1.3 as default, then install gems
install_ruby_packages() {
    # Install rbenv
    if ! command -v rbenv &>/dev/null; then
        substep_info "Installing rbenv..."
        brew install rbenv ruby-build
        eval "$(rbenv init - zsh)" # needed to install gems - already set for Fish
        substep_success "rbenv installed."
    fi

    # Install Ruby 3.1.3 with rbenv and set as default
    if ! rbenv versions | grep -q 3.1.3; then
        substep_info "Installing Ruby 3.1.3..."
        rbenv install 3.1.3
        rbenv global 3.1.3
        rbenv rehash
        substep_success "Ruby 3.1.3 installed and set as default for rbenv."
    fi

    # Install gems
    info "Installing Ruby gems..."
    gem install $(cat ruby_packages.txt)
    success "Ruby gems installed."
}

# Define a function for installing packages with Rust
install_rust_packages() {
    if ! command -v $(which rustc) &>/dev/null; then
        substep_info "Rust not found. Installing..."
        brew install rust rustup-init
        rustup-init
        if ! command -v $(which rustc) &>/dev/null; then
            error "Failed to install Rust. Exiting."
            exit 1
        fi
        substep_success "Rust installed."
    fi
    info "Installing Rust packages..."
    rustup update
    cargo install $(cat "$rust_packages")
    success "Finished installing Rust packages."
}

# Call each installation function
install_brew_packages
install_node_packages
install_python_packages
install_ruby_packages
install_rust_packages
