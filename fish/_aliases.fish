# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
  alias l='exa -la'
  alias la='exa -la'
  alias ld='exa -lgh'
  alias lda='exa -lagh'
  alias ll='exa -lg'

# Workflow
	alias code='code-insiders'
	alias cll='clear; exa -lg'
  alias siz='du -khsc' #show the size of a directory
  alias wget='wget -c' #resume wget by default

# Paths
	alias dropbox='cd ~/Dropbox\ \(Portside\)' #PATH DROPBOX FOR BUSINESS
	alias projects='~/Projects; and exa -lg' #list all project groups
	alias work='~/Projects/work; and exa -lg'
	alias wp='~/Projects/wordpress; and exa -lg'
	alias pg='~/Projects/playground; and exa -lg'

	alias cuts='~/Projects/personal/dot_files; and eval $EDITOR .'

# Set the shell to zsh quickly
	alias zshell='chsh -s /usr/local/bin/zsh'

# Homebrew Cask
  alias casks='brew cask list'

# Git
	#alias git='hub'
  alias clone='git clone'
  alias master='git co master'
  alias push='git push'

	git config --global alias.logs 'log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Network
	alias ip="dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
	alias localip="ipconfig getifaddr en0" #internal network IP
	alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
	alias ping='ping -c 5' # PING WITH PACKET COUNT
	alias speedtest='speedtest-cli'

# View HTTP traffic
	alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
