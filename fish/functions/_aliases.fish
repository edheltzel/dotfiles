

# Navigation
function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

function l
    command eza -Flagh --sort name --git --icons --group-directories-first $argv
end
function ll
    command eza -Flagh --git --icons --group-directories-first --sort modified $argv
end
function la
    command eza -Fla --icons
end
function tree
    command eza --tree --icons $argv
end
function cll
    command clear; and eza -Flah --icons --sort modified $argv
end

# Project shortcuts/aliases
function projects
    cd ~/Developer
end
function dev
    cd ~/Developer
end
function work
    cd ~/Developer/work
end
function dots
    cd ~/Developer/dotfiles; and eval $EDITOR .
end
function cuts
    ~/Developer/dotfiles; and eval $EDITOR .
end

# Language Support
alias pn pnpm
alias px 'pnpm dlx'
alias undo git-undo
alias nah 'git reset --hard && git clean -df'

# Editors and Utilities
alias code code-insiders
alias mux tmux
alias top btm
alias bottom btm
alias serve miniserve

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias sniff "sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""



# SSH and localhost
function hostfile --description 'Opens local host file in the default editor'
    eval sudo $EDITOR /etc/hosts
end

function lssh --description 'Quickly list all hosts in ssh config'
    command grep -w -i Host ~/.ssh/config | sed s/Host//
end

function editssh --description 'Opens ssh known host file in the default editor'
    eval $EDITOR ~/.ssh
end

# Lighthouse for performance testing
function lh --description 'alias for lighthouse'
    set current_date (date "+%Y-%m-%d")
    set current_time (date "+%H-%M-%S")
    command lighthouse $argv --output=html --output-path=./lighthouse/$current_date__$current_time.html --view
end

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
function o --description 'alias o=open'
    open $argv
end

function oo --description 'alias oo=open .'
    open . $argv
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

# Repositiory shortcuts
function repo
    set -l repo_path (repodir $argv)
    echo "$repo_path"
    cd "$repo_path"
end

function repodir
    set repo_base ~/Developer
    set repo_path (find "$repo_base" -mindepth 2 -maxdepth 2 -type d -name "*$argv*" | head -n 1)
    if not test "$argv"; or not test "$repo_path"
        set repo_path "$repo_base"
    end
    echo "$repo_path"
end

function forrepos --description 'Evaluates $argv for all repo folders'
    for d in (find ~/Developer -mindepth 2 -maxdepth 2 ! -path . -type d)
        pushd $d
        set repo (basename $d)
        echo $repo
        eval (abbrex $argv)
        popd >/dev/null
    end
end

# Laravel
alias art 'php artisan'
alias tinker 'php artisan tinker'
alias mfs 'php artisan migrate:fresh --seed'
alias phpunit vendor/bin/phpunit
alias pest vendor/bin/pest
alias vapor vendor/bin/vapor
