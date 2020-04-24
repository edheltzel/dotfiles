# Setting up the Path
set -e fish_user_paths
set -U fish_user_paths "/usr/local/sbin" $fish_user_paths #homebrew

source ~/.config/fish/_importSources.fish

# Start Starship
eval (starship init fish)

# Vim Mode
#fish_vi_key_bindings

# Using Homebrew Ruby
set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
#set -U fish_user_paths (ruby -e 'print Gem.user_dir')/bin $fish_user_paths
#set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
