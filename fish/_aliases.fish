# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end
function l; exa -Falh; end
function ll; exa -Flagh --git; end
function ls; grc ls; end
function la; exa -Fal; end
function lld; exa -Flagh --git --group-directories-first; end
function ld; exa -lghF --git --group-directories-first; end
function tree; exa --tree; end

# Docker
function dc; docker-compose; end
function dcrun; docker-compose run --rm; end

# Workflow
function cll; clear; and exa -Flah; end
alias code='code-insiders'
function siz; du -khsc; end
function wget; wget -c; end
function cask; brew cask; end

# Paths
function projects; cd ~/Projects; end
function work; cd ~/Projects/work/epluno; end

function cuts; ~/Projects/personal/dot_files; and eval $EDITOR .; end
function dots; cd ~/Projects/personal/dot_files; end
function upp; update packages; end

# Homebrew Cask
function casks; brew cask list; end

# Git
	alias git='hub'
  alias git='lab'

# Network
	alias ip="dig +short myip.opendns.com @resolver1.opendns.com" # dumps [YOUR PUBLIC IP] [URL IP]
	alias localip="ipconfig getifaddr en0" #internal network IP
	alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
	alias speedtest='speedtest-cli'

# View HTTP traffic
	alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
	alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
