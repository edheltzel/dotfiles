

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
    command eza -lagh --sort name --git --icons --group-directories-first $argv
end
function ll
    command eza -lagh --git --icons --group-directories-first --sort modified $argv
end
function la
    command eza -la --icons
end
function tree
    command eza --tree --icons $argv
end
function cll
    command clear; and eza -lah --icons --sort modified $argv
end

# Project shortcuts/aliases
alias projects 'cd ~/Developer'
alias dev 'cd ~/Developer'
alias work 'cd ~/Developer/work'
alias dots 'cd ~/.dotfiles'
function cuts
    ~/.dotfiles; and eval $EDITOR .
end

# Language Support
alias pn pnpm
alias px 'pnpm dlx'
alias undo git-undo
alias cbr  'git-cbr'
alias nah 'git reset --hard && git clean -df'

# Editors and Utilities
alias code code-insiders
alias top btm
alias bottom btm
alias serve miniserve

function tldrf --description 'tldr with fzf preview and search'
  tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
end



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

# Git and Repositiory shortcuts

# Github PR checkout with search and preview
function ghprcheck
  set_color red
  if test (command -v git); and git rev-parse --is-inside-work-tree >/dev/null 2>&1
    GH_FORCE_TTY=100% gh pr list | fzf --ansi --preview 'GH_FORCE_TTY=100% gh issue view {1}' --preview-window down --header-lines 3 | awk '{print $1}' | xargs gh pr checkout
  else
      echo -e "\e[31mError: Not a Git repository\e[0m"
  end
  set_color normal
end

# Chekout recent branch updates with search an preview
function git-cbr
  set_color red
  if test (command -v git); and git rev-parse --is-inside-work-tree >/dev/null 2>&1
    git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs git checkout
  else
      echo -e "\e[31mError: Not a Git repository\e[0m"
  end
  set_color normal
end

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
