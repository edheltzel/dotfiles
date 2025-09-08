# set default key bindings
set -g fish_key_bindings fish_default_key_bindings

# Source GRC - Disabled for performance (was causing 17+ second startup delay)
# source /opt/homebrew/etc/grc.fish

# Source Multi-function files
source ~/.config/fish/functions/_aliases.fish
source ~/.config/fish/functions/_utils.fish
source ~/.config/fish/functions/_backup_restore.fish

# Terminal integration
source ~/.config/fish/utils/iterm2_shell_integration.fish

zoxide init fish | source
