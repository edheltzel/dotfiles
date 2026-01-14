# Colorize grep output (good for log files)
alias grep "grep --color=auto"
alias egrep "egrep --color=auto"
alias fgrep "fgrep --color=auto"
# gitnow
alias sta state
alias cma commit-all
alias cm commit
alias gs state

# Confirm before overwriting
alias cp "cp -Ri"
alias mv "mv -i"
alias rm "rm -i"

# Utilities 
alias md "mkdir -p"
alias cwd pwd

# Navigation
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias ...... "cd ../../../../.."
alias l "eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first"
alias ll "eza -lagh --git --icons --group-directories-first"
alias la "eza -lagh --git --icons --group-directories-first --sort modified"
alias cll "clear; and eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first"
alias tree "eza -Ta --icons --ignore-glob=\"node_modules|.git|.vscode|.DS_Store\""
alias ltd "eza -TaD --icons --ignore-glob=\"node_modules|.git|.vscode|.DS_Store\""

# Shortcuts
alias dev "cd ~/Developer"
alias work "cd ~/Developer/work"
alias sites "cd ~/Sites"
alias dots "cd ~/.dotfiles"
alias neoed "cd ~/.dotfiles/neoed/.config/nvim"
alias neo "cd ~/.dotfiles/neoed/.config/nvim"
alias fld "cd \"/Users/ed/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱ \""

# Actions
alias e '$EDITOR' # open in Default Editor
alias o open
alias oo "open ."
alias oa "open -a"
alias del trash
alias sdel "sudo rm -rf"

# Editors and Utilities
alias serve miniserve #start a simple http server
alias du dua
alias wget "wget -c"

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o \"inet6\\? \\(\\([0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)\" | sed -e \"s/inet6* //\""
alias sniff "sudo ngrep -d \"en1\" -t \"^(GET|POST) \" \"tcp and port 80\""
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias whois "grc whois" # colorized whois

# SSH and localhost
alias hostfile "eval sudo nvim /etc/hosts"
alias editssh "eval nvim ~/.ssh"

# Docker aliases
alias dk docker
alias dc docker-compose

#### Language Support ####
# Node - PNPM
alias pn pnpm
alias px "pnpm dlx"

# PHP - Laravel
alias art "php artisan"
alias tinker "php artisan tinker"
alias mfs "php artisan migrate:fresh --seed"
alias phpunit vendor/bin/phpunit
alias pest vendor/bin/pest
alias vapor vendor/bin/vapor
