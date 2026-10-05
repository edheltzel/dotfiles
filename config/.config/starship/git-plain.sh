#!/usr/bin/env bash
# Stock git segments for repos GitButler is not managing. Always exits 0.
# The live config disables these modules so $all stays quiet in butler repos.
# This renders them from a copy with that flag flipped.
src="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
cfg="$(mktemp)"
awk '
  /^\[git_(commit|state|metrics|status)\]$/ { print; sect = 1; next }
  sect && /^disabled[[:space:]]*=/ { print "disabled = false"; sect = 0; next }
  /^\[/ { sect = 0 }
  { print }
' "$src" > "$cfg"
STARSHIP_CONFIG="$cfg" starship prompt --profile gitplain --terminal-width "${COLUMNS:-80}"
rm -f "$cfg"
exit 0
