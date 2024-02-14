##### source ######
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/aliases.zsh

# Load zsh-syntax-highlighting
source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###### load custom fuctions ######
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done
