# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# homebrew
export PATH=/opt/homebrew/bin:$PATH

##### Sourcing plugins extensions #####
#######################################
# auto suggest
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3f4964"
# fzf and z
# source ~/.config/zsh/navigation/navigation.zsh
# fish style abbreviations and Aliases
# source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
# source ~/.config/zsh/aliases/aliases.zsh
# startship prompt
eval "$(starship init zsh)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
