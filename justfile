# justfile for dotfiles management

set shell := ["bash", "-cu"]

stow_packages := "dots git fish config neoed local"

yellow := '\033[33m'
green := '\033[32m'
white := '\033[37m'
clr := '\033[0m'

# Show available recipes (default)
default:
    @just --list

# Bootstrap a new machine
install:
    @echo "{{yellow}}Running bootstrap to provision the system...{{clr}}"
    @./install.sh
    @echo "{{green}}System provisioning complete!{{clr}}"

# Symlink all dotfiles with Stow
run:
    @for pkg in {{stow_packages}}; do \
        stow $pkg; \
    done
    @echo "Dotfiles stowed successfully"

# Add individual package with Stow (e.g., just stow fish)
stow pkg:
    @if echo "{{stow_packages}}" | grep -qw "{{pkg}}"; then \
        stow {{pkg}}; \
        echo "{{pkg}} was added"; \
    else \
        echo "Error: Package '{{pkg}}' not found. Available: {{stow_packages}}"; \
        exit 1; \
    fi

# Remove individual package with Stow (e.g., just unstow fish)
unstow pkg:
    @if echo "{{stow_packages}}" | grep -qw "{{pkg}}"; then \
        stow --delete {{pkg}}; \
        echo "{{pkg}} was removed"; \
    else \
        echo "Error: Package '{{pkg}}' not found. Available: {{stow_packages}}"; \
        exit 1; \
    fi

# Restow all dotfiles packages
update:
    @for pkg in {{stow_packages}}; do \
        if [ "$pkg" = "fish" ]; then \
            rm -f ~/.config/fish/conf.d/brew.fish ~/.config/fish/conf.d/fish-ssh-agent.fish; \
        fi; \
        stow --restow $pkg; \
    done
    @echo "{{green}}Dotfiles updated successfully{{clr}} - run {{yellow}}reload{{clr}} to apply changes to Fish"

# Remove all dotfile symlinks
delete:
    @for pkg in {{stow_packages}}; do \
        stow --delete $pkg; \
    done
    @echo "{{white}}Dotfiles zapped! ⚡️"

# Aliases
alias up := update
alias add := stow
alias remove := unstow
