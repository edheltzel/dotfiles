# Bootstrap: point Zsh to XDG-compliant config directory
# This is the only file that lives in $HOME — everything else is under ZDOTDIR.
export ZDOTDIR="$HOME/.config/zsh"

# Source the real .zshenv from ZDOTDIR
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
