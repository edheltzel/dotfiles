# Zsh config — prompt + plugins + modular configs
# Paths and exports handled by .zshenv (loaded before this file)

[[ -o interactive ]] || return

# --- Mise (runtime manager) ---
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# --- Antidote plugin manager ---
# Try ZDOTDIR-local install first, fall back to Homebrew
if [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
else
  source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
fi
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

# --- Zsh options (Fish-like behavior) ---
setopt AUTO_CD              # cd by typing a directory name alone
setopt AUTO_PUSHD           # Push dirs to stack automatically
setopt PUSHD_IGNORE_DUPS    # No duplicate dirs in pushd stack
setopt INTERACTIVE_COMMENTS # Allow # comments in interactive shell
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_SAVE_NO_DUPS    # Don't save duplicate history entries
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history
setopt HIST_IGNORE_SPACE    # Don't record commands starting with a space
setopt SHARE_HISTORY        # Share history between all sessions
setopt EXTENDED_HISTORY     # Record timestamp in history (: <time>:<elapsed>;<cmd>)
setopt APPEND_HISTORY       # Append to, don't overwrite, history file
setopt CORRECT              # Offer spelling correction

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

# --- Completions ---
# Add custom completions directory to fpath before compinit
fpath=("${ZDOTDIR:-$HOME}/completions" $fpath)

autoload -Uz compinit

# Only rebuild completion dump once per day (speeds up shell init)
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive tab complete
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# --- Key bindings (emacs mode, matching Fish defaults) ---
bindkey -e

# History substring search — bind after plugin loads
bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow
bindkey '^P'   history-substring-search-up    # Ctrl+P
bindkey '^N'   history-substring-search-down  # Ctrl+N

# --- chpwd hook: run eza after every directory change (like the custom cd.fish) ---
chpwd() {
  eza --long --all --header --git --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first
}

# --- Autoload custom functions from functions/ ---
fpath=("${ZDOTDIR:-$HOME}/functions" $fpath)
autoload -Uz "${ZDOTDIR:-$HOME}/functions/"*(N.:t) 2>/dev/null

# --- Source modular configs from .zshrc.d/ ---
for conf in "${ZDOTDIR:-$HOME}/.zshrc.d/"*.zsh(N); do
  source "$conf"
done

# --- Prompt engine (change ZSH_PROMPT in secrets.zsh to swap) ---
ZSH_PROMPT="${ZSH_PROMPT:-starship}"

case "$ZSH_PROMPT" in
  starship)   eval "$(starship init zsh)" ;;
  oh-my-posh) eval "$(oh-my-posh init zsh --config ~/.config/starship-ish.omp.json)" ;;
esac

# --- Atlas (PAI) ---
alias atlas='bun /Users/ed/.claude/skills/PAI/Tools/pai.ts'

# --- Nvim shell integration ---
if [[ "$TERM_PROGRAM" == "nvim" ]]; then
  source "$(nvim --locate-shell-integration-path zsh 2>/dev/null)" 2>/dev/null
fi
