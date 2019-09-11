# Setting up the Path
set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
status --is-interactive; and source (rbenv init -|psub) #rbenv init fish

# Source Colors
source ~/.config/fish/_colors.fish
# Source Aliases
source ~/.config/fish/_aliases.fish
# Source Exports
source ~/.config/fish/_exports.fish

# Set the emoji width for iTerm
set -g fish_emoji_width 2

# Start Starship
eval (starship init fish)

