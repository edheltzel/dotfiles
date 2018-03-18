# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# Workflow
	alias code='code-insiders'
	alias cll='clear; exa -lg'

# Paths
	alias dropbox='cd ~/Dropbox\ \(Portside\)' #PATH DROPBOX FOR BUSINESS
	alias sites='~/Sites; and exa -lg'
	alias projects='~/Projects; and exa -lg'
	alias cuts='~/Projects/dot_files; and code .'

# Set the shell to zsh quickly
	alias zshell='chsh -s /usr/local/bin/zsh'

# Git
	#alias git='hub' 
  alias push='git push'
  alias master='git co master'
  alias clone='git clone'
	git config --global alias.logs 'log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Network
	alias ip="dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
	alias localip="ipconfig getifaddr en0" #internal network IP
	alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
	alias ping='ping -c 5' # PING WITH PACKET COUNT
	alias hostfile='$EDITOR /Volumes/$VOL/private/etc/hosts' # HOST FILE MODS
	alias speedtest='speed-test'

# View HTTP traffic
	alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
