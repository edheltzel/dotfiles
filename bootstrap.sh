#!/bin/bash

# Define variables
DOTFILES_REPO="https://github.com/edheltzel/dotfiles.git"
PROJECTS_DIR="$HOME/Developer"
DOTFILES_DIR="$PROJECTS_DIR/dotfiles-test"

# Define functions for prompts, banners, and errors
print_prompt() {
    echo -e "\033[1m$1\033[0m"
}

function print_banner() {
    local message="$1"
    echo -e "${YELLOW}====================================================${NC}"
    echo -e "${YELLOW} NOTE: $message${NC}"
    echo -e "${YELLOW}====================================================${NC}"
}

print_error() {
    local message="$1"
    echo -e "${YELLOW}====================================================${NC}"
    echo -e "${YELLOW} ERROR: $message${NC}"
    echo -e "${YELLOW}====================================================${NC}"
}

## 

# Create the Developer directory if it does not exist
if [ ! -d "$PROJECTS_DIR" ]; then
    mkdir "$PROJECTS_DIR"
fi

# Clone the dotfiles repository
if ! git clone $DOTFILES_REPO $DOTFILES_DIR &> /dev/null; then
    print_error "Failed to clone dotfiles repository. Please check your internet connection and try again."
    exit 1
fi

# Run the installation script in the dotfiles directory
if ! bash $DOTFILES_DIR/install.sh &> /dev/null; then
    print_error "Failed to install dotfiles. Please check the installation script and try again."
    exit 1
fi

print_banner "You might need to restart your computer for some changes to take effect."
