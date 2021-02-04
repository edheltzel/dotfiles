# Setting up the Path
set -e fish_user_paths
#set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew
set -g fish_user_paths "/opt/homebrew/bin" $fish_user_paths # homebrew ARM

# rbenv
set -Ux fish_user_paths $HOME/.rbenv/bin $fish_user_paths
eval (rbenv init - | source )

# openssl to path
set -g fish_user_paths "/opt/homebrew/opt/openssl@1.1/bin" $fish_user_paths
# homebrew curl to path - default curl uses an outdated version
set -g fish_user_paths "/opt/homebrew/opt/curl/bin" $fish_user_paths

# Custom sourcing of colors, exports, grc, multi-function fish files
source ~/.config/fish/conf.d/__imports.fish

# Start Starship Prompt
starship init fish | source

# Vim Mode
fish_vi_key_bindings
