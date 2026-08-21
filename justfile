# justfile for dotfiles management

set shell := ["bash", "-cu"]

stow_packages := "dots git fish zsh config neoed local"

yellow := '\033[33m'
green := '\033[32m'
white := '\033[37m'
clr := '\033[0m'

# Show available recipes (default)
default:
    @just --list

# Bootstrap a new machine (full provision)
install:
    @printf "{{yellow}}Running bootstrap to provision the system...{{clr}}\n"
    @./install.sh bootstrap
    @printf "{{green}}System provisioning complete!{{clr}}\n"

# Symlink all dotfiles with Stow (idempotent)
link:
    @./install.sh link

# List available stow packages
list:
    @printf "{{yellow}}Available stow packages:{{clr}}\n"
    @for pkg in {{stow_packages}}; do \
        printf "  {{green}}%s{{clr}}\n" "$pkg"; \
    done

# Add individual package with Stow (e.g., just stow fish)
stow pkg="":
    @if [ -z "{{pkg}}" ]; then \
        just list; \
    elif echo "{{stow_packages}}" | grep -qw "{{pkg}}"; then \
        stow {{pkg}}; \
        echo "{{pkg}} stowed successfully"; \
    else \
        echo "Error: Package '{{pkg}}' not found. Available: {{stow_packages}}"; \
        exit 1; \
    fi

# Remove individual package with Stow (e.g., just unstow fish)
unstow pkg:
    @if echo "{{stow_packages}}" | grep -qw "{{pkg}}"; then \
        stow --delete {{pkg}}; \
        echo "{{pkg}} unstowed successfully"; \
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
        if [ "$pkg" = "zsh" ]; then \
            rm -f ~/.config/zsh/.zcompdump*; \
        fi; \
        stow --restow $pkg; \
    done
    @printf "{{green}}Dotfiles updated successfully{{clr}} - run {{yellow}}reload{{clr}} to apply changes to your shell\n"

# Remove all dotfile symlinks
delete:
    @for pkg in {{stow_packages}}; do \
        stow --delete $pkg; \
    done
    @printf "{{white}}Dotfiles zapped! ⚡️{{clr}}\n"

# Install tracked .githooks into .git/hooks. Do not point core.hooksPath at
# .githooks: GitButler writes managed wrappers into hooksPath, and committing
# those wrappers is the delete/untracked conflict this recipe prevents.
hooks:
    #!/usr/bin/env bash
    set -euo pipefail
    root="$(git rev-parse --show-toplevel)"
    git config --unset-all core.hooksPath || true
    mkdir -p "$root/.git/hooks"
    for hook in pre-commit commit-msg; do
      printf '#!/bin/sh\nexec "%s/.githooks/%s" "$@"\n' "$root" "$hook" > "$root/.git/hooks/$hook"
      chmod +x "$root/.git/hooks/$hook"
    done
    printf "{{green}}git hooks installed{{clr}} -> .git/hooks (sources in .githooks)\n"

# Aliases
alias up := update
alias add := stow
alias remove := unstow
alias run := link
alias bootstrap := install
