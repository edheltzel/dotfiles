set -x --global EDITOR code #set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -x --global VOL xxx #set primary volume for workstation

# GOLANG configurations
set -x GOPATH ~/.go
#set -x GOROOT /usr/local/opt/go/libexec
set -x PATH $PATH $GOPATH/bin

# fzf and fd helpers for NeoVim
set -x FZF_DEFAULT_COMMAND "fd --type f"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
