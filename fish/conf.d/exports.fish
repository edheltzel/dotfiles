# set default key bindings
set -g fish_key_bindings fish_default_key_bindings

# Source GRC
# https://github.com/oh-my-fish/plugin-grc/issues/20#issue-296031557
source /opt/homebrew/etc/grc.fish

# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -x --global EDITOR code-insiders
string match -q "$TERM_PROGRAM" "vscode"
and . (code-insiders --locate-shell-integration-path fish)
#set primary volume for workstation
set -x --global VOL xxx

# Source Multi-function files
source ~/.config/fish/functions/_devops.fish
source ~/.config/fish/functions/_navigation.fish
