# Environment variables — interactive-only additions (≈ exports.fish)
# Non-interactive exports live in .zshenv; these are interactive extras.

# Source secrets if present (gitignored)
[[ -f "${ZDOTDIR:-$HOME}/secrets.zsh" ]] && source "${ZDOTDIR:-$HOME}/secrets.zsh"
