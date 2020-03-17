# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
alias l='exa -Flahr --group-directories-first'
alias ll='exa -Flaghr --git --group-directories-first'
alias la='exa -Fla'
alias lm='exa -Flaghr --git --group-directories-first --sort modified --reverse'
alias ld='exa -Flgh --git --group-directories-first'
alias tree='exa --tree'
alias ls='grc ls'

alias atm='neofetch'
alias mymac='neofetch'
alias about='neofetch'

# Workflow
alias code='code-insiders'
alias vim='nvim'
alias cll='clear; and exa -Flah --sort modified'
alias siz='du -khsc'
alias wget='wget -c'
alias cask='brew cask'
alias casks='brew cask list'
alias upp='topgrade --cleanup -y --no-retry'
alias update='topgrade'
alias vb='VBoxManage'
alias shrink='tinypng'
alias mux='tmuxinator'
# alias go='richgo' # so go test prints rich output
