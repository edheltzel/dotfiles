[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

##### plugins ######
plug "zap-zsh/supercharge"

# Load and initialise completion system
autoload -Uz compinit
compinit

##### source ######
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/aliases.zsh

###### load custom fuctions ######
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done
