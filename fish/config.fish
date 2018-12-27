# Setting up the Path
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
status --is-interactive; and source (rbenv init -|psub) #rbenv init fish

# Source Colors
source ~/.config/fish/_colors.fish
# Source Aliases
source ~/.config/fish/_aliases.fish
# Source Exports
source ~/.config/fish/_exports.fish


# SpaceFish
set SPACEFISH_CHAR_SYMBOL "❯"
# set SPACEFISH_TIME_SHOW trues
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

