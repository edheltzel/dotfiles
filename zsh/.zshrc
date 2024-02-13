##### Sourcing plugins extensions #####
#######################################
# fzf and z
# source ~/.config/zsh/navigation/navigation.zsh
# fish style abbreviations and Aliases
# source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/aliases.zsh

# load custom fuctions
for function_file in ~/.config/zsh/functions/*; do
  source "$function_file"
done

# startship prompt
eval "$(starship init zsh)"
