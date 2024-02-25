speed() {
  if [[ $# -gt 0 ]]; then
    networkQuality "$@"
  else
    networkQuality -v
  fi
}
