# Setting up the Path
set -e fish_user_paths
set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
status --is-interactive; and source (rbenv init -|psub) #rbenv init fish

# # Source Colors
source ~/.config/fish/_colors.fish
# # Source Aliases
source ~/.config/fish/_aliases.fish
# # Source Exports
source ~/.config/fish/_exports.fish

# Start Starship
eval (starship init fish)
