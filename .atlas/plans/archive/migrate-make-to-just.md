# Plan: Migrate from Make to Just

## Overview

Replace the `Makefile` with a `justfile` for dotfile management. `just` is already installed (added in `ca72971a`). The migration is 1:1 — every `make` target gets a `just` recipe with identical behavior, plus ergonomic improvements from `just`'s native features.

## Why Just

| Feature | Make | Just |
|---------|------|------|
| Indentation | Tabs required | Spaces work |
| Arguments | `make stow pkg=fish` (env var) | `just stow fish` (positional) |
| Self-documenting | Custom awk hack | Built-in `just --list` |
| Aliases | Separate phony targets | `alias` keyword |
| Shell | `/bin/sh` default | Configurable per-recipe |
| Error messages | Cryptic | Clear |

## Steps

### Step 1: Create `justfile`

Create `justfile` in repo root with these recipes:

```just
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
```

**Key improvements over Makefile:**
- `just stow fish` instead of `make stow pkg=fish` — positional args, cleaner UX
- `just --list` replaces the awk-based help — built-in, formatted, from comments
- `alias` keyword for shortcuts — no duplicate phony targets
- Package validation uses POSIX `grep -qw` instead of bash `[[ =~ ]]`

### Step 2: Update Documentation

Files to update (replace `make` commands with `just` equivalents):

| File | References | Changes |
|------|------------|---------|
| `CLAUDE.md` | ~12 references | `make install` → `just install`, `make stow pkg=fish` → `just stow fish`, etc. |
| `AGENTS.md` | ~10 references | Same pattern as CLAUDE.md |
| `README.md` | ~10 references | Same + update prose about "makefile" and "make tasks" |
| `neoed/.config/nvim/README.md` | 1 reference | `make stow pkg=nvim` → `just stow nvim` |

**Notable:** `fish/.config/fish/conf.d/paths.fish` line 16 has GNU make in PATH — this stays, it's system make, not dotfiles-specific.

### Step 3: Remove Makefile

Delete `Makefile` from repo root.

### Step 4: Verify

- Run `just` (should show recipe list)
- Run `just stow fish` (should stow fish package)
- Run `just unstow fish` (should unstow)
- Run `just update` (should restow all with fish cleanup)
- Grep for orphaned `make` references in docs (excluding non-dotfiles context like karabiner README prose)

## Command Comparison

| Before | After |
|--------|-------|
| `make` | `just` |
| `make install` | `just install` |
| `make run` | `just run` |
| `make stow pkg=fish` | `just stow fish` |
| `make unstow pkg=fish` | `just unstow fish` |
| `make update` / `make up` | `just update` / `just up` |
| `make delete` | `just delete` |

## Risk

Low. This is a 1:1 migration of a local-only tool. `just` is already installed. If anything breaks, `stow` commands still work directly.
