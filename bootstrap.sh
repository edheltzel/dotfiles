#!/bin/bash

# Define variables
DOTFILES_REPO="https://github.com/edheltzel/dotfiles.git"
PROJECTS_DIR="$HOME/Projects"
DOTFILES_DIR="$PROJECTS_DIR/dotfiles-test"

# Define functions for prompts, banners, and errors
print_prompt() {
    echo -e "\033[1m$1\033[0m"
}

print_banner() {
    echo -e "\033[1;34m$1\033[0m"
}

print_error() {
    echo -e "\033[1;31mError:\033[0m $1"
}

# Create the Projects directory if it does not exist
if [ ! -d "$PROJECTS_DIR" ]; then
    mkdir "$PROJECTS_DIR"
fi

# Clone the dotfiles repository
if ! git clone $DOTFILES_REPO $DOTFILES_DIR &> /dev/null; then
    print_error "Failed to clone dotfiles repository. Please check your internet connection and try again."
    exit 1
fi

# Run the installation script in the dotfiles directory
# if ! bash $DOTFILES_DIR/install.sh &> /dev/null; then
#     print_error "Failed to install dotfiles. Please check the installation script and try again."
#     exit 1
# fi

print_banner "You might need to restart your computer for some changes to take effect."
