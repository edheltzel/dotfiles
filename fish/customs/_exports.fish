set -x --global EDITOR code-insiders $EDITOR #set Visual Studio Code Insiders as default editor use code, code-insiders, subl or vim
set -x --global VOL rdm $VOL

# GoLang
set -x GOPATH ~/Projects/Go
set -x GOROOT /usr/local/opt/go/libexec

set -x PATH $PATH $GOROOT/bin $GOPATH/bin

