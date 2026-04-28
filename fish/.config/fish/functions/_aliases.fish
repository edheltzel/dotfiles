# Colorize grep output (good for log files)
alias grep "grep --color=auto"
alias egrep "egrep --color=auto"
alias fgrep "fgrep --color=auto"
# gitnow
alias gcma commit-all
alias gcm commit
alias gs state

# Confirm before overwriting
alias cp "cp -Ri"
alias mv "mv -i"
alias rm "rm -i"

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

# Network shortcuts/aliases and utilities
alias ip "dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
alias ipl "ipconfig getifaddr en0" #internal network IP
alias ips "ifconfig -a | grep -o \"inet6\\? \\(\\([0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)\" | sed -e \"s/inet6* //\""
alias sniff "sudo ngrep -d \"en1\" -t \"^(GET|POST) \" \"tcp and port 80\""
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\\: .* | GET \\/.*\""
