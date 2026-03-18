# Start ssh-agent and load SSH keys using macOS Keychain (≈ fish-ssh-agent.fish)

if ! ssh-add -l &>/dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
fi

ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
