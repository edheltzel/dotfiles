# Non-interactive environment — loaded for ALL Zsh instances (scripts, cron, etc.)
# Paths, exports, and variables needed before .zshrc loads.

# --- PATH deduplication (like fish_add_path) ---
typeset -U path

# --- Homebrew (Apple Silicon first, Intel fallback) ---
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export HOMEBREW_CELLAR=/opt/homebrew/Cellar
  export HOMEBREW_REPOSITORY=/opt/homebrew
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  export MANPATH="/opt/homebrew/share/man${MANPATH:+:$MANPATH}"
  export INFOPATH="/opt/homebrew/share/info${INFOPATH:+:$INFOPATH}"
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
  export HOMEBREW_CELLAR=/usr/local/Cellar
  export HOMEBREW_REPOSITORY=/usr/local/Homebrew
  path=(/usr/local/bin /usr/local/sbin $path)
  export MANPATH="/usr/local/share/man${MANPATH:+:$MANPATH}"
  export INFOPATH="/usr/local/share/info${INFOPATH:+:$INFOPATH}"
fi

# --- XDG Base Directory ---
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# --- Core tools ---
export EDITOR=nvim
export TERMINAL=wezterm
export LC_ALL=en_US.UTF-8
export MANPAGER="nvim +Man!"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export EZA_COLORS="gm=33;1"

# --- Go ---
export GOPATH="$HOME/.go"
path=($GOPATH/bin $path)

# --- Node / PNPM ---
export PNPM_HOME="$HOME/Library/pnpm"
path=($PNPM_HOME $path)

# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
path=($BUN_INSTALL/bin $path)

# --- Python (pyenv) ---
export PYENV_ROOT="$HOME/.pyenv"
path=($PYENV_ROOT/bin $path)

# --- Rust (cargo) ---
path=($HOME/.cargo/bin $path)

# --- Ruby gems ---
path=($HOME/.gem/ruby/3.0.2/bin $path)

# --- PHP ---
path=($HOME/.composer/vendor/bin $path)

# --- Other tools ---
path=(
  $HOME/.local/bin
  $HOMEBREW_PREFIX/opt/openssl@1.1/bin
  $HOMEBREW_PREFIX/opt/make/libexec/gnubin
  /Applications/Warp.app/Contents/MacOS
  $HOME/.antigravity/antigravity/bin
  $path
)

# --- FZF ---
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Projects ---
export PROJECTS_DIR="$HOME/Developer"

# --- Netlify credential helper ---
[[ -f "$HOME/Library/Preferences/netlify/helper/path.zsh.inc" ]] \
  && source "$HOME/Library/Preferences/netlify/helper/path.zsh.inc"
