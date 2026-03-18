# Lazy-load zoxide — only inits on first z/zi call (≈ zoxide.fish)

__lazy_zoxide() {
  unfunction __lazy_zoxide z zi 2>/dev/null
  eval "$(zoxide init zsh)"
}

z()  { __lazy_zoxide && __zoxide_z "$@"; }
zi() { __lazy_zoxide && __zoxide_zi "$@"; }
