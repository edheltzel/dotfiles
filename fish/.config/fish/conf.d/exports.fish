# set default key bindings
set -g fish_key_bindings fish_default_key_bindings

# Source FNM
#fnm env --use-on-cd | source
# Source GRC
source /opt/homebrew/etc/grc.fish

# Source Multi-function files
source ~/.config/fish/functions/_aliases.fish
source ~/.config/fish/functions/_utils.fish
source ~/.config/fish/functions/_backup_restore.fish

# Srouce Completion files
