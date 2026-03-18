# Homebrew integration (≈ brew.fish)
# Primary setup done in .zshenv; this ensures shellenv is loaded interactively.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
