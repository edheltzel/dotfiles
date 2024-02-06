#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Include functions
. scripts/functions.sh

# Function to keep sudo alive
sudo_keep_alive() {
  while true; do sudo -n true; sleep 60; done
}

# Function to check for required commands
check_required_commands() {
  local required_commands=("curl" "git" "stow")
  for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: $cmd is not installed." >&2
      exit 1
    fi
  done
}

PROJECTS_DIR="$HOME/Developer"

# Start the bootstrap process referencing functions.sh
install_xcode
install_git

# Create the ~/Developer directory if it does not exist
if [ ! -d "$PROJECTS_DIR" ]; then
    mkdir -p "$PROJECTS_DIR"
fi

# Main installation process
mainInstall() {
  check_required_commands

  # Confirmation prompt
  warning "This will install & configure dotfiles on your system. It may overwrite existing files."
  read -p "Are you sure you want to proceed? (y/n) " confirm
  if [[ "$confirm" != "y" ]]; then
    echo -e "${RED}Installation aborted."
    exit 0
  fi

  # Check for sudo password and keep alive
  if sudo --validate; then
    sudo_keep_alive &
    SUDO_PID=$!
    trap 'kill "$SUDO_PID"' EXIT
    substep_info "Sudo password saved. Continuing with script."
  else
    substep_error "Incorrect sudo password. Exiting script."
    exit 1
  fi

  # check/install xcode and homebrew
  install_xcode
  install_homebrew

  # Display banner and prompt user to continue
  banner
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Run setup scripts in order
    source ./packages/packages.sh

    # Consolidated stow commands
    declare -a stow_dirs=("dots" "git" "fish" "nvim" "config" "local" "warp" "vscode")
    for dir in "${stow_dirs[@]}"; do
      stow "$dir"
    done

    source ./duti/duti.sh
    source ./macos/macos.sh
    source ./git/git.sh

    # Check if Fish is installed and set it as the default shell if desired
    if command -v fish &>/dev/null; then
      if ! grep -q "$(command -v fish)" /etc/shells; then
        substep_info "Adding Fish to available shells..."
        sudo sh -c "echo $(command -v fish) >> /etc/shells"
      fi
      read -p "Do you want to set Fish as your default shell? (y/N): " -n 1 -r
      echo    # Move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s "$(command -v fish)"
      fi
    fi

    success "Dotfile setup complete."
  else
    error "Aborted."
  fi
}

# Run the main function
mainInstall
