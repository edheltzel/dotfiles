# set Visual Studio Code as default editor use code, code-insiders, subl or vim
set -gx EDITOR code-insiders -w

string match -q "$TERM_PROGRAM" vscode
and . (code --locate-shell-integration-path fish)

# Volumes
set -gx VOL xxx
set -gx DROPBOX $HOME/Library/CloudStorage/Dropbox-RDM
