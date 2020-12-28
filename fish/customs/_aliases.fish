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
alias cll='clear; and exa -Flah --sort modified'

# Workflow
alias siz='du -khsc'
alias wget='wget -c'
alias mux='tmux'
alias ytop='ytop -f'

# Editors
alias vim='nvim'

# Golang/Rust/Python
alias pip='pip3'
alias python='python3'
