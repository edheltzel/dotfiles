# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -x --global EDITOR code-insiders
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
#set primary volume for workstation
set -x --global VOL xxx
