#!/bin/sh
alias reload='exec $SHELL'
alias local='cd ~/.local'
alias config='cd ~/.config'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# ls aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias l='eza -lagh --sort name --git --icons --group-directories-first $*'
alias ll='eza -lagh --sort modified --git --icons --group-directories-first $*'
alias la='eza -la --icons $*'
alias tree='eza --tree --icons $*'
alias cll='clear && eza -lah --icons --sort modified'

# Projects shortcuts/aliases and actions
alias projects='cd ~/Developer'
alias dev='cd ~/Developer'
alias work='cd ~/Developer/work'
alias dots='cd ~/.dotfiles'
alias cust='cd ~/.dotfiles && eval $EDITOR .'
alias o='open $*'
alias oa='open -a /Applications/$*'
alias del='trash $*'
alias sdel='sudo rm -rf $*'

# Editors/Utitlities
alias code='code-insiders'
alias top='btm'
alias bottom='btm'
alias serve='miniserve'
alias du='dua'
alias zip='ouch compress $*'
alias unzip='ouch decompress $*'
alias listzip='ouch list $*'

# Network shortcuts/alises
alias whois='grc whois'
alias hostfile='eval sudo $EDITOR /etc/hosts'
alias editssh='eval $EDITOR ~/.ssh'
alias lssh='grep -w -i Host ~/.ssh/config | sed s/Host//'

# Docker aliases
alias dk='docker'
alias dc='docker-compose'

# Node/Pnpm support
alias pn='pnpm'
alias px='pnpm dlx'

# Laravel
alias art='php artisan'
alias tinker='php artisan tinker'
alias mfs='php artisan migrate:fresh --seed'
alias phpunit='vendor/bin/phpunit'
alias pest='vendor/bin/pest'
alias vapor='vendor/bin/vapor'
