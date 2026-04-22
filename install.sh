#!/usr/bin/env bash
#
# install.sh — unified dotfiles installer
#
# Usage:
#   ./install.sh <subcommand> [flags]
#
# Subcommands:
#   bootstrap     Full machine provision (Xcode CLT, Homebrew, packages,
#                 Stow, duti, macOS prefs, git config, fish as default)
#   link          Symlink dotfiles only (GNU Stow, idempotent)
#   help          Show this help (default when no subcommand given)
#
# Flags (bootstrap):
#   -y, --yes         Skip confirmation prompts (non-interactive)
#   --no-packages     Skip Homebrew bundle
#   --no-macos        Skip macOS system preferences
#   -h, --help        Show help and exit
#
# Remote one-liner:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/edheltzel/dotfiles/master/install.sh)" -- bootstrap

set -euo pipefail

# macOS only — fail fast on other platforms
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: this installer targets macOS (Darwin) only. Detected: $(uname -s)" >&2
  exit 1
fi

# ────────────────────────────────────────────────────────────────
# Config
# ────────────────────────────────────────────────────────────────
readonly SOURCE_REPO="https://github.com/edheltzel/dotfiles"
readonly TARBALL_URL="${SOURCE_REPO}/tarball/master"
readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
readonly PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Developer}"

# Keep in sync with justfile:stow_packages
readonly STOW_PACKAGES=(dots git fish zsh config neoed local)

# Flag defaults
SKIP_CONFIRM=0
SKIP_PACKAGES=0
SKIP_MACOS=0

# ────────────────────────────────────────────────────────────────
# Self-detection + remote bootstrap
# Runs BEFORE sourcing functions.sh — must be self-contained.
# ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

if [ -z "$SCRIPT_DIR" ] || [ ! -f "$SCRIPT_DIR/justfile" ] || [ ! -f "$SCRIPT_DIR/packages/packages.sh" ]; then
  # Remote mode: script is being piped from curl or running from a temp dir.
  echo "Running install.sh in remote mode — will clone repo to $DOTFILES_DIR"

  if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "Existing repo at $DOTFILES_DIR — skipping clone"
  elif [ -d "$DOTFILES_DIR" ] && [ -n "$(ls -A "$DOTFILES_DIR" 2>/dev/null)" ]; then
    echo "Error: $DOTFILES_DIR exists and is not empty, but is not a git repo." >&2
    echo "Remove or move it, then re-run this installer." >&2
    exit 1
  else
    mkdir -p "$DOTFILES_DIR"
    if command -v git >/dev/null 2>&1; then
      git clone "$SOURCE_REPO" "$DOTFILES_DIR"
    elif command -v curl >/dev/null 2>&1; then
      curl -#fL "$TARBALL_URL" | tar -xz -C "$DOTFILES_DIR" --strip-components=1
    elif command -v wget >/dev/null 2>&1; then
      wget --no-check-certificate -qO- "$TARBALL_URL" | tar -xz -C "$DOTFILES_DIR" --strip-components=1
    else
      echo "Error: git, curl, or wget is required to fetch the dotfiles." >&2
      exit 1
    fi
  fi

  # Verify the clone/extract produced a usable script before re-exec
  if [ ! -f "$DOTFILES_DIR/install.sh" ]; then
    echo "Error: $DOTFILES_DIR/install.sh missing after fetch. Partial or corrupt download?" >&2
    exit 1
  fi

  echo "Re-executing install.sh from $DOTFILES_DIR"
  exec "$DOTFILES_DIR/install.sh" "$@"
fi

cd "$SCRIPT_DIR"

# ────────────────────────────────────────────────────────────────
# Load shared helpers (error/success/info/warning, install_xcode,
# install_homebrew, sudo_keep_alive, symlink, etc.)
# ────────────────────────────────────────────────────────────────
# shellcheck source=scripts/functions.sh
. "$SCRIPT_DIR/scripts/functions.sh"
DOTFILES_FUNCTIONS_LOADED=1

# One-line fatal for CLI usage problems; runtime failures use error() banner + exit.
die() { echo "Error: $1" >&2; exit "${2:-1}"; }

# Stow a list of packages. With mode=strict, stow conflicts abort (set -e);
# with mode=lenient, conflicts are reported and the loop continues.
_run_stow() {
  local mode="$1"; shift
  info "Linking dotfiles with GNU Stow..."
  for pkg in "$@"; do
    if [ ! -d "$SCRIPT_DIR/$pkg" ]; then
      substep_error "Stow package '$pkg' not found — skipping"
      continue
    fi
    substep_info "Stowing $pkg"
    if [ "$mode" = "lenient" ]; then
      stow --restow "$pkg" || substep_error "Stow conflict for '$pkg' — resolve manually then re-run './install.sh link'"
    else
      stow --restow "$pkg"
    fi
  done
}

# ────────────────────────────────────────────────────────────────
# Subcommand implementations
# ────────────────────────────────────────────────────────────────
cmd_help() {
  cat <<'EOF'
Usage: ./install.sh <subcommand> [flags]

Subcommands:
  bootstrap     Full machine provision:
                  - Xcode Command Line Tools
                  - Homebrew + Brewfile bundle
                  - Language package managers (FNM, pipx, rbenv, rustup, Bun)
                  - GNU Stow symlinks for all dotfiles packages
                  - macOS system preferences
                  - File type associations (duti)
                  - Machine-specific git config
                  - Fish as default shell (optional)

  link          Stow-symlink dotfiles only — idempotent, safe to re-run.
                Does NOT install any software. Use this when you already
                have a bootstrapped machine and just want to (re)link files.

  help          Show this help (default when no subcommand is given).

Flags (apply to bootstrap):
  -y, --yes         Skip confirmation prompts (non-interactive mode)
  --no-packages     Skip Homebrew bundle and language package managers
  --no-macos        Skip macOS system preferences script
  -h, --help        Show this help and exit

Notes:
  - Re-running bootstrap will run `brew upgrade` on all installed packages.
  - `link` is always safe to re-run; it uses `stow --restow`.
  - See .atlas/plans/ for design rationale.

Examples:
  ./install.sh bootstrap              # full provision, interactive
  ./install.sh bootstrap --yes        # full provision, no prompts
  ./install.sh bootstrap --no-macos   # skip macOS sysprefs
  ./install.sh link                   # (re)symlink dotfiles only
EOF
}

cmd_link() {
  check_required_commands
  _run_stow lenient "${STOW_PACKAGES[@]}"
  success "Dotfiles linked."
}

cmd_bootstrap() {
  # stow is installed by Homebrew later, so don't require it up front.
  for cmd in curl git; do
    command -v "$cmd" >/dev/null 2>&1 || die "$cmd is required to bootstrap but is not installed."
  done

  if [ "$SKIP_CONFIRM" -eq 0 ]; then
    warning "This will install & configure dotfiles on your system. It may overwrite existing files."
    read -r -p "Are you sure you want to proceed? (y/N) " confirm
    [[ "$confirm" == [yY] ]] || { error "Installation aborted."; exit 0; }
  fi

  # -v is portable back to older macOS (--validate is Sudo 1.9+)
  if sudo -v; then
    sudo_keep_alive &
    SUDO_PID=$!
    trap 'kill "$SUDO_PID" 2>/dev/null || true' EXIT
    substep_info "Sudo validated. Continuing."
  else
    die "Incorrect sudo password. Exiting."
  fi

  install_xcode
  install_homebrew

  git submodule update --init --recursive
  mkdir -p "$PROJECTS_DIR"

  if [ "$SKIP_PACKAGES" -eq 0 ]; then
    info "Installing language/package managers..."
    # packages.sh uses relative paths internally; run it from its own dir
    ( cd "$SCRIPT_DIR/packages" && . ./packages.sh )
  else
    info "Skipping packages (--no-packages)"
  fi

  _run_stow strict "${STOW_PACKAGES[@]}"

  ( cd "$SCRIPT_DIR/duti" && . ./duti.sh )

  if [ "$SKIP_MACOS" -eq 0 ]; then
    ( cd "$SCRIPT_DIR/macos" && . ./macos.sh )
  else
    info "Skipping macOS sysprefs (--no-macos)"
  fi

  ( cd "$SCRIPT_DIR/git" && . ./git.sh )

  # Fish as default shell — irreversible per-user preference, own prompt
  if command -v fish >/dev/null 2>&1; then
    fish_path="$(command -v fish)"
    if ! grep -q "$fish_path" /etc/shells; then
      substep_info "Adding Fish to /etc/shells..."
      echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi
    if [ "$SKIP_CONFIRM" -eq 0 ]; then
      read -r -p "Set Fish as your default shell? (y/N) " set_fish
      [[ "$set_fish" == [yY] ]] && chsh -s "$fish_path"
    else
      info "Non-interactive mode: Fish NOT set as default shell. Run manually: chsh -s $fish_path"
    fi
  fi

  success "Dotfile setup complete."
}

# ────────────────────────────────────────────────────────────────
# Argument parsing
# ────────────────────────────────────────────────────────────────
if [ "$#" -eq 0 ]; then
  cmd_help
  exit 0
fi

SUBCOMMAND=""
case "${1:-}" in
  bootstrap|link|help) SUBCOMMAND="$1"; shift ;;
  -h|--help)           cmd_help; exit 0 ;;
  *)                   die "Unknown subcommand: '$1'. Run './install.sh help' for usage." ;;
esac

while [ "$#" -gt 0 ]; do
  case "$1" in
    -y|--yes)      SKIP_CONFIRM=1 ;;
    --no-packages) SKIP_PACKAGES=1 ;;
    --no-macos)    SKIP_MACOS=1 ;;
    -h|--help)     cmd_help; exit 0 ;;
    *)             die "Unknown flag: '$1'. Run './install.sh help' for usage." ;;
  esac
  shift
done

case "$SUBCOMMAND" in
  bootstrap) cmd_bootstrap ;;
  link)      cmd_link ;;
  help)      cmd_help ;;
esac
