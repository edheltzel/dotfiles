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

# Define banner function to display changes about to be made
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

# Define a function for displaying an error message
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

localgitconfig() {
    local hostname=$(hostname)
    local signingkey=""

    if [ "$hostname" = "BigMac" ]; then
        signingkey="/Users/ed/.ssh/id_ed25519.pub"
    elif [ "$hostname" = "MacDaddy" ]; then
        signingkey="/Users/ed/.ssh/id_rsa.pub"
    else
        substep_error "Unknown hostname '$hostname'. Skipping configuration of Git signingkey."
        return 1
    fi

    if [ ! -f "$HOME/.gitconfig.local" ]; then
        touch "$HOME/.gitconfig.local"
    fi

    if grep -q "\[user\]" "$HOME/.gitconfig.local"; then
        sed "/\[user\]/a\\
signingkey = $signingkey
" "$HOME/.gitconfig.local" >"$HOME/.gitconfig.local.tmp"
        mv "$HOME/.gitconfig.local.tmp" "$HOME/.gitconfig.local"
    else
        echo "[user]" >>"$HOME/.gitconfig.local"
        echo "	signingkey = $signingkey" >>"$HOME/.gitconfig.local"
    fi

    substep_success "Git signingkey configured for hostname '$hostname'."
}
