#! /usr/bin/env sh
REPO_NAME="${REPO_NAME:-}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BLACK='\033[0;30m'
NC='\033[0m'

banner() {
    echo ""
    echo -e "${BLUE}*************************************************${NC}"
    echo -e "${BLUE}*                                               *${NC}"
    echo -e "${BLUE}*          🧰 Dotfiles Setup                    *${NC}"
    echo -e "${BLUE}*                                               *${NC}"
    echo -e "${BLUE}*************************************************${NC}"
    echo ""
    echo -e "${GREEN}This script will install and setup the following:${NC}"
    echo -e " - Xcode Command Line Tools"
    echo -e " - Homebrew"
    echo -e " - Git (via Homebrew)"
    echo -e " - Fish shell (via Homebrew)"
    echo -e " - Config files for various applications"
    echo -e " - Set default applications for file types"
    echo -e " - Configure macOS settings"
    echo ""
    read -p "$(echo -e '${YELLOW}Do you want to continue? (y/n): ${NC}')" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${RED}Installation cancelled.${NC}"
        exit 1
    fi
}

symlink() {
    OVERWRITTEN=""
    if [ -e "$2" ] || [ -h "$2" ]; then
        OVERWRITTEN="(Overwritten)"
        if ! rm -r "$2"; then
            substep_error "Failed to remove existing file(s) at $2."
        fi
    fi
    if ln -s "$1" "$2"; then
        substep_success "Symlinked $2 to $1. $OVERWRITTEN"
    else
        substep_error "Symlinking $2 to $1 failed."
    fi
}

clear_broken_symlinks() {
    find -L "$1" -type l | while read fn; do
        if rm "$fn"; then
            substep_success "Removed broken symlink at $fn."
        else
            substep_error "Failed to remove broken symlink at $fn."
        fi
    done
}

error() {
    local message="$1"
    echo -e "${RED}====================================================${NC}"
    echo -e "${RED} ERROR: $message${NC}"
    echo -e "${RED}====================================================${NC}"
}

info() {
    local message="$1"
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE} INFO: $message${NC}"
    echo -e "${BLUE}====================================================${NC}"
}

warning() {
    local message="$1"
    local padded_message=" WARNING: $message"
    local line=$(printf "%${#padded_message}s" | tr " " "=")
    echo -e "${YELLOW}$line${NC}"
    echo -e "${YELLOW} WARNING:${NC} $message${NC}"
    echo -e "${YELLOW}$line${NC}"
}

success() {
    local message="$1"
    echo -e "${GREEN}====================================================${NC}"
    echo -e "${GREEN} SUCCESS: $message${NC}"
    echo -e "${GREEN}====================================================${NC}"
}

substep_info() {
    local message="$1"
    echo -e "${YELLOW}====================================================${NC}"
    echo -e "${YELLOW} INFO: $message${NC}"
    echo -e "${YELLOW}====================================================${NC}"
}

substep_success() {
    local message="$1"
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN} SUCCESS: $message${NC}"
    echo -e "${CYAN}====================================================${NC}"
}

substep_error() {
    local message="$1"
    echo -e "${MAGENTA}====================================================${NC}"
    echo -e "${MAGENTA} ERROR: $message${NC}"
    echo -e "${MAGENTA}====================================================${NC}"
}

sudo_keep_alive() {
  while true; do sudo -n true; sleep 60; done
}

install_xcode() {
  if ! xcode-select --print-path &>/dev/null; then
    print_banner "Xcode Command Line Tools not found. Installing Xcode Command Line Tools..."
    xcode-select --install &>/dev/null
    # Wait for Xcode Command Line Tools installation
    until xcode-select --print-path &>/dev/null; do sleep 5; done
    print_banner "Xcode Command Line Tools installation complete."
  else
    print_banner "Xcode Command Line Tools already installed. Skipping installation."
  fi
}

install_git() {
  if ! command -v git &>/dev/null; then
    print_banner "Git not found. Installing Git..."
    # Assuming Homebrew is installed, install Git
    brew install git
    if ! command -v git &>/dev/null; then
      print_error "Error installing Git. Exiting script."
      exit 1
    fi
    print_banner "Git installation complete."
  else
    print_banner "Git already installed. Skipping installation."
  fi
}

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    substep_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! command -v brew &>/dev/null; then
      substep_error "Error installing Homebrew. Exiting script."
      exit 1
    fi
    success "Homebrew installation complete."
  else
    substep_success "Homebrew already installed. Skipping installation."
  fi
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
