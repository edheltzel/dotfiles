# Lazy-load FNM — only inits when node/npm/npx first called (≈ config.fish)

__lazy_fnm() {
  unfunction __lazy_fnm node npm npx 2>/dev/null
  eval "$(fnm env --use-on-cd)"
}

node()  { __lazy_fnm && command node "$@"; }
npm()   { __lazy_fnm && command npm "$@"; }
npx()   { __lazy_fnm && command bunx "$@"; }  # npx → bunx (matching Fish config)
