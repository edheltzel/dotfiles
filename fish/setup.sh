#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
FISH_PATH="$(realpath ~/.config/fish)"

info "Setting up fish shell..."

substep_info "Creating fish config folders..."
mkdir -p "$FISH_PATH/functions"
mkdir -p "$FISH_PATH/customs"
mkdir -p "$FISH_PATH/completions"
mkdir -p "$FISH_PATH/conf.d"
mkdir -p "$FISH_PATH/utils"

find * -name "*fish*" | while read fn; do
    symlink "$SOURCE/$fn" "$FISH_PATH/$fn"
done

clear_broken_symlinks "$FISH_PATH"


set_fish_shell() {
    if grep --quiet fish <<< "$SHELL"; then
        success "Fish shell is already set up."
    else
        substep_info "Adding fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet "/usr/local/bin/fish" /etc/shells; then
            substep_success "Fish executable already exists in /etc/shells."
        else
            if sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"; then
                substep_success "Fish executable added to /etc/shells."
            else
                substep_error "Failed adding Fish executable to /etc/shells."
                return 1
            fi
        fi
        substep_info "Changing shell to fish"
        if chsh -s /usr/local/bin/fish; then
            substep_success "Changed shell to fish"
        else
            substep_error "Failed changing shell to fish"
            return 2
        fi
        substep_info "Running fish initial setup"
        fish -c "setup"
    fi
}

if set_fish_shell; then
    success "Successfully set up fish shell. Make sure you run Fisher manually"
else
    error "Failed setting up fish shell."
fi
