#!/bin/bash

# include functions
. scripts/functions.sh

# Check for sudo password and keep alive
if sudo --validate; then
  while true; do sudo --non-interactive true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  banner "Sudo password saved. Continuing with script."
else
  banner "Incorrect sudo password. Exiting script."
  exit 1
fi

# Check for Xcode installation
if ! xcode-select --print-path &>/dev/null; then
  banner "Xcode not found. Installing Xcode..."
  xcode-select --install &>/dev/null
  # Wait for Xcode installation
  until xcode-select --print-path &>/dev/null; do sleep 5; done
  banner "Xcode installation complete."
else
  banner "Xcode already installed. Skipping installation."
fi

# Check for Homebrew installation
if ! $(which brew); then
  banner "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if ! $(which brew); then
    banner "Error installing Homebrew. Exiting script."
    exit 1
  fi
  banner "Homebrew installation complete."
else
  banner "Homebrew already installed. Skipping installation."
fi

# Display banner and prompt user to continue
banner
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Run setup scripts in order
    source ./homebrew/setup.sh
    source ./node/setup.sh
    source ./python/setup.sh
    source ./fish/setup.sh
    source ./rust/setup.sh
    source ./ruby/setup.sh
    source ./git/setup.sh
    source ./nvim/setup.sh
    source ./duti/setup.sh
    source ./macos/setup.sh

    # Check if Fish is installed and set it as the default shell if desired
    if command -v fish &> /dev/null; then
        if ! grep -q "$(which fish)" /etc/shells; then
            echo "Adding Fish to available shells..."
            sudo sh -c "echo $(which fish) >> /etc/shells"
        fi
        read -p "Do you want to set Fish as your default shell? (y/n) " -n 1 -r
        echo -e ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            chsh -s $(which fish)
        fi
    fi

    echo "Dotfile setup complete."
else
    echo "Aborted."
fi
