# FZF keybindings reference (≈ keys.fish)
# Terminal emulators remap Cmd+Ctrl -> Ctrl+Alt
# Ctrl+T   = Search files (fzf default)
# Ctrl+R   = Search history (fzf default)
# Alt+C    = cd into directory (fzf default)
#
# Ghostty remaps (if configured):
# Cmd+Ctrl+F = Search Directory
# Cmd+Ctrl+R = Search History
# Cmd+Ctrl+L = Search Git Log
# Cmd+Ctrl+S = Search Git Status

# Source fzf keybindings and completion if installed via Homebrew
if [[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
fi
if [[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
fi
