#set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -x --global EDITOR code-insiders
#set primary volume for workstation
set -x --global VOL xxx

# GOLANG configurations
set -x GOPATH ~/.go

# add the go bin path to be able to execute our programs
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

# fzf and fd helpers for NeoVim
set -x FZF_DEFAULT_COMMAND "fd --type f"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
