#! /usr/bin/env sh
REPO_NAME="${REPO_NAME:-}"
TITLE=""


# Define banner function to display changes about to be made
banner() {
    echo ""
    echo -e "\033[0;36m*************************************************\033[0m"
    echo -e "\033[0;36m*                                               *\033[0m"
    echo -e "\033[0;36m*          🧰 Dotfiles Setup                    *\033[0m"
    echo -e "\033[0;36m*                                               *\033[0m"
    echo -e "\033[0;36m*************************************************\033[0m"
    echo ""
    echo -e "\033[0;32mThis script will install and setup the following:\033[0m"
    echo -e " - Xcode Command Line Tools"
    echo -e " - Homebrew"
    echo -e " - Git (via Homebrew)"
    echo -e " - Fish shell (via Homebrew)"
    echo -e " - Config files for various applications"
    echo -e " - Set default applications for file types"
    echo -e " - Configure macOS settings"
    echo ""
    read -p "$(echo -e '\033[0;33mDo you want to continue? (y/n): \033[0m')" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "\033[0;31mInstallation cancelled.\033[0m"
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

# Took these printing functions from https://github.com/Sajjadhosn/dotfiles
coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

info() {
    coloredEcho "$1" blue "========>"
}

success() {
    coloredEcho "$1" green "========>"
}

error() {
    coloredEcho "$1" red "========>"
}

substep_info() {
    coloredEcho "$1" magenta "===="
}

substep_success() {
    coloredEcho "$1" cyan "===="
}

substep_error() {
    coloredEcho "$1" red "===="
}
