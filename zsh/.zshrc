##### plugins ######
source $HOMEBREW_PREFIX/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autopair/autopair.zsh

##### source ######
source $XDG_CONFIG_HOME/zsh/exports.zsh
source $XDG_CONFIG_HOME/zsh/aliases.zsh

###### load custom fuctions ######
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done
