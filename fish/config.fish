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

# SpaceFish
set -g SPACEFISH_CHAR_SYMBOL ❯
set -g SPACEFISH_EXEC_TIME_ELAPSED 2

set -U grcplugin_ls --color -l

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ed/google-cloud-sdk/path.fish.inc' ]; . '/Users/ed/google-cloud-sdk/path.fish.inc'; end
