# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias la 'eza -la --icons'
function l --description 'list all files with directories first sorted by name'
    command eza -lagh --sort name --git --icons --group-directories-first $argv
end
function ll --description 'list all files with directories first sorted by modified date'
    command eza -lagh --git --icons --group-directories-first --sort modified $argv
end
function tree --description 'list all files in a tree view'
    command eza --tree --icons $argv
end
function cll --description 'clear and list all files sorted by modified date'
    command clear; and eza -lah --icons --sort modified $argv
end

# Project shortcuts/aliases
alias projects 'cd ~/Developer'
alias dev 'cd ~/Developer'
alias work 'cd ~/Developer/work'
alias dots 'cd ~/.dotfiles'
alias cuts 'cd ~/.dotfiles; and eval $EDITOR .'

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

# Editors and Utilities
alias upp topgrade
alias code code-insiders
alias top btm
alias bottom btm
alias serve miniserve #start a simple http server
alias du dua
alias zip 'ouch compress'
alias unzip 'ouch decompress'
alias listzip 'ouch list'
alias lzip 'ouch list'
alias oo 'open .'
alias o open
alias oa 'open -a'
alias del trash
alias sdel 'sudo rm -rf'

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias sniff "sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias whois "grc whois" # colorized whois

# SSH and localhost
alias hostfile 'eval sudo $EDITOR /etc/hosts'
alias editssh 'eval $EDITOR ~/.ssh'
alias lssh 'grep -w -i Host ~/.ssh/config | sed s/Host//'

# Docker/Kubernetes/Vagrant
alias dkc docker-compose
alias dk docker
alias dc docker-compose

# function tldrf --description 'tldr search and preview with fzf'
alias tldrf 'tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

alias cp 'cp -Ri'
