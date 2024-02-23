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

# Language Support
alias pn pnpm
alias px 'pnpm dlx'

# Editors and Utilities
alias code code-insiders
alias top btm
alias bottom btm
alias serve miniserve #start a simple http server
alias du dua

# function tldrf --description 'tldr search and preview with fzf'
alias tldrf 'tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

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
function dk --description 'docker alias'
    command docker $argv
end
function dc --description 'docker-compose alias'
    command docker-compose $argv
end

# Ouch - zip and unzip replacement
function zip --description 'alias for zip using ouch instead of zip'
    command ouch compress $argv
end
function unzip --description 'alias for unzip using ouch instead of unzip'
    command ouch decompress $argv
end
function listzip --description 'alias to list files files in a zip compression'
    command ouch list $argv
end

# Open and Remove/Del shortcuts
function oo --description 'alias oo=open .'
    open .
end
function o --description 'alias o=open'
    open $argv
end
function oa --description 'Open App'
    open -a /Applications/$argv
end

function del --description 'alias del=trash'
    trash $argv
end
function sdel --description 'alias sdel=sudo rm -rf'
    sudo rm -rf $argv
end

# Laravel
alias art 'php artisan'
alias tinker 'php artisan tinker'
alias mfs 'php artisan migrate:fresh --seed'
alias phpunit vendor/bin/phpunit
alias pest vendor/bin/pest
alias vapor vendor/bin/vapor
