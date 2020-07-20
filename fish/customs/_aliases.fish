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


# Homebrew
alias cask='brew cask'
alias casks='brew cask list'

# Apps/VMs/Docker
alias vb='VBoxManage'

# Editors
alias code='code-insiders'
alias vim='nvim'

# Javascript
alias 11ty='eleventy'

# Golang/Rust/Python
# alias go='richgo' # so go test prints rich output
alias pip='pip3'
alias python='python3'
