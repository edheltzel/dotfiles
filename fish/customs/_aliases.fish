# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
alias l='exa -Falh'
alias ll='exa -Flagh --git'
alias la='exa -Fal'
alias lld='exa -Flagh --git --group-directories-first'
alias ld='exa -lghF --git --group-directories-first'
alias tree='exa --tree'
alias ls='grc ls'
# Workflow
alias code='code-insiders'
alias cll='clear; and exa -Flah'
alias siz='du -khsc'
alias wget='wget -c'
alias cask='brew cask'
alias casks='brew cask list'
alias upp='update packages'
alias speedtest='speedtest-cli'

alias go='richgo' # so go test prints rich output
