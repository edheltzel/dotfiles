# Lazy-load rbenv — only inits when ruby/gem/bundle/rake/irb first called (≈ config.fish)

__lazy_rbenv() {
  unfunction __lazy_rbenv ruby gem bundle rake irb 2>/dev/null
  eval "$(rbenv init -)"
}

ruby()   { __lazy_rbenv && command ruby "$@"; }
gem()    { __lazy_rbenv && command gem "$@"; }
bundle() { __lazy_rbenv && command bundle "$@"; }
rake()   { __lazy_rbenv && command rake "$@"; }
irb()    { __lazy_rbenv && command irb "$@"; }
