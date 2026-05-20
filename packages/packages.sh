#!/usr/bin/env bash

# functions.sh may already be loaded by install.sh — only re-source when run standalone
if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi
brew_packages="Brewfile"
node_packages="node_packages.txt"
global_packages="bun_packages.txt"
pnpm_packages="pnpm_packages.txt"
ruby_packages="ruby_packages.txt"
rust_packages="rust_packages.txt"

# Define a function for installing packages with Homebrew
install_brew_packages() {
  if ! command -v brew &>/dev/null; then
    substep_info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! command -v brew &>/dev/null; then
      error "Failed to install Homebrew. Exiting."
      exit 1
    fi
    substep_success "Homebrew installed."
  fi
  info "Installing Homebrew packages..."
  brew update
  brew upgrade
  brew bundle --file="$brew_packages"
  success "Finished installing Homebrew packages."
}

# Install Node with FNM and set latest LTS as default, then install npm packages
install_node_packages() {
  # Install FNM
  if ! command -v fnm &>/dev/null; then
    substep_info "Installing FNM..."
    curl -fsSL https://fnm.vercel.app/install | bash
    eval "$(fnm env --use-on-cd)" # needed to install npm packages - already set for Fish
    substep_success "FNM installed."
  fi

  # Install latest LTS version of Node with FNM and set as default
  if ! fnm use --lts &>/dev/null; then
    info "Installing latest LTS version of Node..."
    fnm install --lts
    fnm alias lts-latest default
    fnm use default
    substep_success "Node LTS installed and set as default for FNM."
  fi

  # Install NPM packages
  info "Installing NPM packages..."
  npm install -g $(cat $node_packages)
  corepack enable
  success "All NPM global packages installed."
}
# Install global packages with Bun
install_bun_packages() {
  bun install -g $(cat $global_packages)
}

# Install global packages with pnpm
install_pnpm_packages() {
  if ! command -v pnpm &>/dev/null; then
    substep_info "pnpm not found. Installing via corepack..."
    corepack enable
    corepack prepare pnpm@latest --activate
    if ! command -v pnpm &>/dev/null; then
      error "Failed to install pnpm. Exiting."
      exit 1
    fi
    substep_success "pnpm installed."
  fi

  # Pre-approve build scripts so install doesn't prompt for puppeteer, bun, etc.
  # pnpm v10+ blocks postinstall scripts by default; the allowlist lives in
  # `pnpm root -g`/pnpm-workspace.yaml.
  local pnpm_global_dir
  pnpm_global_dir=$(pnpm root -g 2>/dev/null)
  if [ -n "$pnpm_global_dir" ] && [ -f "pnpm-workspace.yaml" ]; then
    mkdir -p "$pnpm_global_dir"
    cp "pnpm-workspace.yaml" "$pnpm_global_dir/pnpm-workspace.yaml"
    substep_success "Installed pnpm allowBuilds template → $pnpm_global_dir/pnpm-workspace.yaml"
  fi

  info "Installing pnpm global packages..."
  pnpm add -g $(cat $pnpm_packages)
  success "All pnpm global packages installed."
}

# Install Ruby with rbenv, set 3.3.6 as default, then install gems
install_ruby_packages() {
  # Install rbenv
  if ! command -v rbenv &>/dev/null; then
    substep_info "Installing rbenv..."
    brew install rbenv ruby-build
    eval "$(rbenv init - zsh)" # needed to install gems - already set for Fish
    substep_success "rbenv installed."
  fi

  # Install Ruby 3.3.6 with rbenv and set as default
  if ! rbenv versions --bare | grep -qx 3.3.6; then
    substep_info "Installing Ruby 3.3.6..."
    rbenv install 3.3.6
    rbenv global 3.3.6
    rbenv rehash
    substep_success "Ruby 3.3.6 installed and set as default for rbenv."
  fi

  # Install gems
  info "Installing Ruby gems..."
  gem install $(cat ruby_packages.txt)
  success "Ruby gems installed."
}

# Define a function for installing packages with Rust
install_rust_packages() {
  if ! command -v rustc &>/dev/null; then
    substep_info "Rust not found. Installing..."
    brew install rustup-init
    rustup-init
    if ! command -v rustc &>/dev/null; then
      error "Failed to install Rust. Exiting."
      exit 1
    fi
    substep_success "Rust installed."
  fi
  info "Installing Rust packages..."
  rustup update
  cargo install $(cat "$rust_packages")
  success "Finished installing Rust packages."
}

# ─── Uninstall functions ───────────────────────────────────────────────

uninstall_brew_packages() {
  if ! command -v brew &>/dev/null; then
    error "Homebrew not installed; nothing to uninstall."
    return 1
  fi
  info "Uninstalling Homebrew casks from $brew_packages..."
  brew bundle list --file="$brew_packages" --casks 2>/dev/null | while read -r pkg; do
    [ -z "$pkg" ] && continue
    brew uninstall --cask "$pkg" || true
  done
  info "Uninstalling Homebrew formulae from $brew_packages..."
  brew bundle list --file="$brew_packages" --brews 2>/dev/null | while read -r pkg; do
    [ -z "$pkg" ] && continue
    brew uninstall "$pkg" || true
  done
  success "Finished uninstalling Homebrew packages."
}

uninstall_node_packages() {
  if ! command -v npm &>/dev/null; then
    error "npm not available; nothing to uninstall."
    return 1
  fi
  info "Uninstalling NPM global packages..."
  npm uninstall -g $(cat $node_packages)
  success "NPM global packages uninstalled."
}

uninstall_bun_packages() {
  if ! command -v bun &>/dev/null; then
    error "bun not available; nothing to uninstall."
    return 1
  fi
  info "Uninstalling Bun global packages..."
  bun remove -g $(cat $global_packages)
  success "Bun global packages uninstalled."
}

uninstall_pnpm_packages() {
  if ! command -v pnpm &>/dev/null; then
    error "pnpm not available; nothing to uninstall."
    return 1
  fi
  info "Uninstalling pnpm global packages..."
  pnpm remove -g $(cat $pnpm_packages)
  success "pnpm global packages uninstalled."
}

uninstall_ruby_packages() {
  if ! command -v gem &>/dev/null; then
    error "gem not available; nothing to uninstall."
    return 1
  fi
  info "Uninstalling Ruby gems..."
  # -a: all versions, -I: ignore deps, -x: also remove executables
  gem uninstall -aIx $(cat $ruby_packages) || true
  success "Ruby gems uninstalled."
}

uninstall_rust_packages() {
  if ! command -v cargo &>/dev/null; then
    error "cargo not available; nothing to uninstall."
    return 1
  fi
  info "Uninstalling Rust packages..."
  while read -r pkg; do
    [ -z "$pkg" ] && continue
    cargo uninstall "$pkg" || true
  done < "$rust_packages"
  success "Rust packages uninstalled."
}

# ─── Dispatcher ────────────────────────────────────────────────────────

usage() {
  cat <<EOF
Usage: $(basename "$0") [action] [target]

Actions:
  install    Install packages (default if action omitted)
  uninstall  Uninstall packages listed in the corresponding file

Targets:
  brew    Homebrew packages from Brewfile
  node    Node (FNM) + NPM packages from node_packages.txt
  bun     Bun global packages from bun_packages.txt
  pnpm    pnpm global packages from pnpm_packages.txt
  ruby    Ruby (rbenv) + gems from ruby_packages.txt
  rust    Rust + cargo packages from rust_packages.txt
  all     Every target above

Examples:
  $(basename "$0")                  # install all
  $(basename "$0") bun              # install bun packages
  $(basename "$0") install pnpm     # install pnpm packages
  $(basename "$0") uninstall bun    # uninstall bun packages
  $(basename "$0") uninstall all    # uninstall everything
EOF
}

run_action() {
  local action="$1"
  local target="$2"
  case "$action:$target" in
    install:brew)   install_brew_packages ;;
    install:node)   install_node_packages ;;
    install:bun)    install_bun_packages ;;
    install:pnpm)   install_pnpm_packages ;;
    install:ruby)   install_ruby_packages ;;
    install:rust)   install_rust_packages ;;
    install:all)
      install_brew_packages
      install_node_packages
      install_ruby_packages
      install_rust_packages
      install_bun_packages
      install_pnpm_packages
      ;;
    uninstall:brew) uninstall_brew_packages ;;
    uninstall:node) uninstall_node_packages ;;
    uninstall:bun)  uninstall_bun_packages ;;
    uninstall:pnpm) uninstall_pnpm_packages ;;
    uninstall:ruby) uninstall_ruby_packages ;;
    uninstall:rust) uninstall_rust_packages ;;
    uninstall:all)
      uninstall_bun_packages
      uninstall_pnpm_packages
      uninstall_node_packages
      uninstall_rust_packages
      uninstall_ruby_packages
      uninstall_brew_packages
      ;;
    *)
      error "Unknown action/target: $action $target"
      usage
      exit 1
      ;;
  esac
}

case "${1:-}" in
  ""|all)                 run_action install all ;;
  -h|--help|help)         usage ;;
  install|uninstall)
    action="$1"
    target="${2:-all}"
    run_action "$action" "$target"
    ;;
  brew|node|bun|pnpm|ruby|rust)
    run_action install "$1"
    ;;
  *)
    error "Unknown argument: $1"
    usage
    exit 1
    ;;
esac
