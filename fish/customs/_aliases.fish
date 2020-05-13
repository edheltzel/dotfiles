# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
alias l='exa -Flah --sort name --group-directories-first'
alias ll='exa -Flagh --git --group-directories-first --sort modified'
alias la='exa -Fla'
alias lm='exa -Flagh --git --group-directories-first --sort modified'
alias ld='exa -Flgh --git --group-directories-first'
alias tree='exa --tree'
alias ls='grc ls'

alias about='neofetch'
alias atm='neofetch'
alias mymac='neofetch'

# Workflow
alias 11ty='eleventy'
alias cask='brew cask'
alias casks='brew cask list'
alias cll='clear; and exa -Flah --sort modified'
alias code='code-insiders'
alias siz='du -khsc'
alias update='topgrade --disable gem'
alias updateall='topgrade'
alias vb='VBoxManage'
alias vim='nvim'
alias wget='wget -c'
# alias go='richgo' # so go test prints rich output
