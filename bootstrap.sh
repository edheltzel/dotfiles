#!/bin/bash

# Source the functions file to use predefined colors and functions
. scripts/functions.sh

# Define variables
DOTFILES_REPO="https://github.com/edheltzel/dotfiles.git"
PROJECTS_DIR="$HOME/Developer"
DOTFILES_DIR="$HOME/.dotfiles"

# Start the bootstrap process
install_xcode
install_git

# Create the ~/Developer directory if it does not exist
if [ ! -d "$PROJECTS_DIR" ]; then
    mkdir -p "$PROJECTS_DIR"
fi

# Clone or update the dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    git -C "$DOTFILES_DIR" pull
fi

# Run the installation script in the dotfiles directory
if ! bash "$DOTFILES_DIR/install.sh"; then
    print_error "Failed to install dotfiles. Please check the installation script for errors."
    exit 1
fi

print_banner "Installation complete! Please restart your computer for all changes to take effect."
