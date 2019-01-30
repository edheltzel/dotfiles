# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
  alias l='exa -laF'
  alias la='exa -laF'
  alias ld='exa -lghF'
  alias lda='exa -laghF'
  alias ll='exa -lgF'
  alias ls='exa -F'
  alias vim='nvim'

# Workflow
  alias code='code-insiders'
	alias cll='clear; exa -lg'
  alias siz='du -khsc' #show the size of a directory
  alias wget='wget -c' #resume wget by default
  alias cask='brew cask'
  alias cdl='cd; and clear'

# Paths
	alias dropbox='cd ~/Dropbox\ \(-\)' #PATH DROPBOX FOR BUSINESS
	alias projects='~/Projects; and exa -lgF' #list all project groups
	alias work='~/Projects/work; and exa -lgF'
	alias wp='~/Projects/wordpress; and exa -lgF'
	alias pg='~/Projects/playground; and exa -lgF'

	alias cuts='~/Projects/personal/dot_files; and eval $EDITOR .'
  alias dots='~/Projects/personal/dot_files; and exa -lgF'
  alias upp='update fish gem mas brew npm'

# Set the shell to zsh quickly
	alias zshell='chsh -s /usr/local/bin/zsh'

# Homebrew Cask
  alias casks='brew cask list'

# Tmux
  alias mux='tmuxinator'

# Git
	#alias git='hub'
  alias clone='git clone'
  alias master='git co master'
  alias push='git push'
  alias git='lab'

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
