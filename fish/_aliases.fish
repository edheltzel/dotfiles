# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
  alias l='exa -Falh'
  alias ll='exa -Flagh --git'
  alias ls='grc ls'
  alias la='exa -Fal'
  alias lld='exa -Flagh --git --group-directories-first'
  alias ld='exa -lghF --git --group-directories-first'
  alias tree='exa --tree'

# Docker
  alias dc='docker-compose'
  alias dcrun='docker-compose run --rm'

# Workflow
	alias cll='clear; exa -Flah'
  alias code='code-insiders'
  alias siz='du -khsc' #show the size of a directory
  alias wget='wget -c' #resume wget by default
  alias cask='brew cask'

# Paths
	alias dropbox='cd ~/Dropbox\ \(RDM\)' #PATH DROPBOX FOR BUSINESS
	alias projects='cd ~/Projects' #list all project groups
	alias work='cd ~/Projects/work/epluno'
	alias wp='cd ~/Projects/wordpress'
	alias pg='cd ~/Projects/playground'

	alias cuts='~/Projects/personal/dot_files; and eval $EDITOR .'
  alias dots='cd ~/Projects/personal/dot_files'
  alias upp='update packages'

# Set the shell to zsh quickly
	alias zshell='chsh -s /usr/local/bin/zsh'

# Homebrew Cask
  alias casks='brew cask list'

# Tmux
  alias mux='tmuxinator'

# Git
	alias git='hub'
  alias clone='git clone'
  alias master='git co master'
  alias push='git push'
  alias git='lab' # lab is a wrapper for hub as well

	git config --global alias.logs 'log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Network
	alias ip="dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
	alias localip="ipconfig getifaddr en0" #internal network IP
	alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
	alias speedtest='speedtest-cli'

# View HTTP traffic
	alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
