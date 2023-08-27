#!/bin/bash

# include functions
. scripts/functions.sh

# Confirmation prompt
warning "This will install & configure dotfiles on your system. It may overwrite existing files."
read -p "Are you sure you want to proceed? (y/n) " confirm
if [[ $confirm != "y" ]]; then
  echo -e "${RED} Installation aborded."
  exit 0
fi

# Check for sudo password and keep alive
if sudo --validate; then
  while true; do
    sudo --non-interactive true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
  substep_info "Sudo password saved. Continuing with script."
else
  substep_error "Incorrect sudo password. Exiting script."
  exit 1
fi

# Check for Xcode installation
if
  ! xcode-select --print-path &
  >/dev/null
then
  substep_info "Xcode not found. Installing Xcode..."
  xcode-select --install &
  >/dev/null
  # Wait for Xcode installation
  until
    xcode-select --print-path &
    >/dev/null
  do sleep 5; done
  success "Xcode installation complete."
else
  substep_success "Xcode already installed. Skipping installation."
fi

# Check for Homebrew installation
if ! $(which brew); then
  substep_info "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if ! $(which brew); then
    substep_error "Error installing Homebrew. Exiting script."
    exit 1
  fi
  success "Homebrew installation complete."
else
  substep_success "Homebrew already installed. Skipping installation."
fi

# Display banner and prompt user to continue
banner
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Run setup scripts in order
  source ./packages/setup.sh
  source ./fish/setup.sh
  source ./git/setup.sh
  source ./nvim/setup.sh
  source ./duti/setup.sh
  source ./macos/setup.sh

  # Check if Fish is installed and set it as the default shell if desired
  if
    command -v fish &
    >/dev/null
  then
    if ! grep -q "$(which fish)" /etc/shells; then
      substep_info "Adding Fish to available shells..."
      sudo sh -c "echo $(which fish) >> /etc/shells"
    fi
    read -p "$(echo -e '${YELLOW}Do you want to set Fish as your default shell? (y/n): ${NC}')" -n 1 -r
    echo -e ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      chsh -s $(which fish)
    fi
  fi

  success "Dotfile setup complete."
else
  error "Aborted."
fi
