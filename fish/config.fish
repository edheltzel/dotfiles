# Setting up the Path
set -e fish_user_paths
#set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
set -g fish_user_paths "/opt/homebrew/bin" $fish_user_paths # homebrew ARM

set -g fish_user_paths "/opt/homebrew/opt/openssl@1.1/bin" $fish_user_paths

# rbenv
set -Ux fish_user_paths $HOME/.rbenv/bin $fish_user_paths
eval (rbenv init - | source )

# Custom settings
source ~/.config/fish/conf.d/__imports.fish

# Start Starship
eval (starship init fish)

# Vim Mode
#fish_vi_key_bindings
