#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
    . ../scripts/functions.sh
fi

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

# Get computer name
computer_name=$(scutil --get ComputerName)

if [ "$computer_name" = "BigMac" ]; then
  symlink "$SOURCE/gitconfig-bigmac.local" "$DESTINATION/.gitconfig.local"
elif [ "$computer_name" = "MacDaddy" ]; then
  symlink "$SOURCE/gitconfig-macdaddy.local" "$DESTINATION/.gitconfig.local"
else
  echo "Unknown computer name: $computer_name"
  exit 1
fi

# Ensure this machine's SSH signing key is registered on GitHub as a signing key.
# Without this, locally-valid signatures show as "Unverified" on GitHub after a key rotation.
register_signing_key() {
  local pubkey keybody
  pubkey="$(git config --get user.signingkey)"

  [ -z "$pubkey" ] && return 0
  case "$pubkey" in *.pub) ;; *) return 0 ;; esac   # SSH signing only, not GPG key ids
  [ -f "$pubkey" ] || { warning "Signing key $pubkey not found; skipping GitHub registration"; return 0; }
  command -v gh >/dev/null 2>&1 || { info "gh not installed; skip GitHub signing-key registration"; return 0; }
  gh auth status >/dev/null 2>&1 || { info "gh not authenticated; skip GitHub signing-key registration"; return 0; }

  keybody="$(awk '{print $1" "$2}' "$pubkey")"
  if gh api /user/ssh_signing_keys --jq '.[].key' 2>/dev/null | grep -qF "$keybody"; then
    info "SSH signing key already registered on GitHub"
  elif gh api -X POST /user/ssh_signing_keys \
        -f "title=$computer_name Signing $(date +%Y-%m)" \
        -f "key=$(cat "$pubkey")" >/dev/null 2>&1; then
    success "Registered SSH signing key on GitHub"
  else
    warning "Failed to register SSH signing key on GitHub (check gh token scope: admin:ssh_signing_key)"
  fi
}

register_signing_key
