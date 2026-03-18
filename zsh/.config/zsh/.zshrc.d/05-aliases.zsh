# Aliases (≈ _aliases.fish)
# Direct translations from Fish aliases to Zsh.

# Colorize grep output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# gitnow equivalents
alias gcma="git add -A && git commit -S"
alias gcm="git commit -S"
alias gs="git status"

# Confirm before overwriting
alias cp="cp -Ri"
alias mv="mv -i"
alias rm="rm -i"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# eza file listings
alias l='eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first'
alias ll='eza -lagh --git --icons --group-directories-first'
alias la='eza -lagh --git --icons --group-directories-first --sort modified'
alias cll='clear && eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first'
alias tree='eza -Ta --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'
alias ltd='eza -TaD --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'

# Shortcuts
alias fld='cd "/Users/ed/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱"'
alias fabric="fabric-ai"
alias mux="tmux"
alias zel="zellij"

# Network
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias ipl='ipconfig getifaddr en0'
alias ips='ifconfig -a | grep -o "inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)" | sed -e "s/inet6* //"'
alias sniff='sudo ngrep -d "en1" -t "^(GET|POST) " "tcp and port 80"'
alias httpdump='sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E "Host\: .* | GET \/.*"'
