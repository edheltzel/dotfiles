##### source ######
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/aliases.zsh

###### load custom fuctions ######
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done
