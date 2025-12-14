# Start ssh-agent and load SSH keys using macOS Keychain
if status is-interactive
    # Start agent if not running (use -c for csh/fish compatible output)
    if not ssh-add -l >/dev/null 2>&1
        eval (ssh-agent -c) >/dev/null
    end

    # Add keys with Keychain integration
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
end
