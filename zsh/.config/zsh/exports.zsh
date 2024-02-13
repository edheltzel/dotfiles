#!/bin/sh
eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew
eval "$(starship init zsh)"               # starship prompt
eval "$(fnm env --use-on-cd)"             # fnm node version manager
eval "$(zoxide init zsh)"                 # zoxide directory jump
# eval "`pip completion --zsh`"
