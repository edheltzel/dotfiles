##### plugins ######
source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autopair/autopair.zsh
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

##### source ######
source $XDG_CONFIG_HOME/zsh/exports.zsh
source $XDG_CONFIG_HOME/zsh/aliases.zsh

###### load custom fuctions ######
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done

###### zsh abbrivations ######
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH

  autoload -Uz compinit
  compinit
fi
