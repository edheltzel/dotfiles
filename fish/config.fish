# Setting up the Path
set -e fish_user_paths
set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
status --is-interactive; and source (rbenv init -|psub) #rbenv init fish

source ~/.config/fish/_importSources.fish

# Start Starship
eval (starship init fish)

# Vim Mode
#fish_vi_key_bindings

# Auto Node Version Switching
source ~/.config/fish/functions/fish_avn.fish
