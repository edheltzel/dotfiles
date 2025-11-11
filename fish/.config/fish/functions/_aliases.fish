# Colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'

# Git aliases (no included in gitconfig)
alias sta state # gitnow
alias cma commit-all # gitnow
alias cm commit # gitnow

# Confirm before overwriting
alias cp 'cp -Ri'
alias mv 'mv -i'
alias rm 'rm -i'

# Create/delete directories
alias md 'mkdir -p'
alias rd 'rmdir -p'

# Topgrade 
alias tg topgrade

# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias l 'eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first'
alias ll 'eza -lagh --git --icons --group-directories-first'
alias la 'eza -lagh --git --icons --group-directories-first --sort modified'
alias cll 'clear; and eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first'

# Tree view
alias tree 'eza -Ta --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'
alias ltd 'eza -TaD --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'

# Project shortcuts/aliases
alias projects 'cd ~/Developer'
alias dev 'cd ~/Developer'
alias work 'cd ~/Developer/work'
alias sites 'cd ~/Sites'
alias dots 'cd ~/.dotfiles'

# Actions
alias e '$EDITOR' # open in Default Editor
alias cuts 'eval $EDITOR ~/.dotfiles'
alias o open
alias oo 'open .'
alias oa 'open -a'
alias del trash
alias sdel 'sudo rm -rf'

# Editors and Utilities
# alias code windsurf
alias serve miniserve #start a simple http server
alias du dua
# alias zip 'ouch compress'
# alias unzip 'ouch decompress'
# alias listzip 'ouch list'
# alias lzip 'ouch list'
alias wget 'wget -c'
alias mux zellij
alias wz wezterm

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias sniff "sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias whois "grc whois" # colorized whois

# SSH and localhost
alias hostfile 'eval sudo nvim /etc/hosts'
alias editssh 'eval nvim ~/.ssh'

# Docker aliases
alias dk docker
alias dc docker-compose

#### Language Support ####
# Node - PNPM
alias pn pnpm
alias px 'pnpm dlx'

# PHP - Laravel
alias art 'php artisan'
alias tinker 'php artisan tinker'
alias mfs 'php artisan migrate:fresh --seed'
alias phpunit vendor/bin/phpunit
alias pest vendor/bin/pest
alias vapor vendor/bin/vapor
