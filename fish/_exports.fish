set --export --global EDITOR code-insiders $EDITOR #set Visual Studio Code Insiders as default editor use code, code-insiders, subl or vim
set --export --global VOL rdm $VOL

# GoLang
set -x GOPATH ~/Development/Go
set -x GOROOT /usr/local/opt/go/libexec

set -x PATH $PATH $GOROOT/bin $GOPATH/bin


#set --export --global LANG en_US $LANG
#set --export --global LC_ALL en_US.UTF-8 $LC_ALL
