#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source="$repo/config/.config/herdr-app"
target="${XDG_CONFIG_HOME:-$HOME/.config}/herdr-app"
backup=""

if [[ -L "$target" ]]; then
  printf "Herdr config must be a real directory, not a symlink: %s\n" "$target" >&2
  exit 1
fi
mkdir -p "$target"

for path in "$source/keys.json" "$source/settings.json" "$source"/themes/*.json "$source"/sounds/* "$source"/mods/*/main.js "$source"/mods/*/mod.json; do
  [[ -f "$path" ]] || continue
  name="${path#"$source"/}"
  destination="$target/$name"
  parent=$(dirname "$destination")
  mkdir -p "$parent"
  if [[ -d "$destination" ]]; then
    printf "Refusing to replace directory: %s\n" "$destination" >&2
    exit 1
  fi
  if [[ ! "$destination" -ef "$path" ]]; then
    if [[ -e "$destination" || -L "$destination" ]]; then
      if [[ -z "$backup" ]]; then
        state="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/herdr-app"
        mkdir -p "$state"
        backup=$(mktemp -d "$state/backup.XXXXXX")
        printf "Herdr config backup: %s\n" "$backup"
      fi
      mkdir -p "$backup/$(dirname "$name")"
      cp -pP "$destination" "$backup/$name"
    fi
    staging=$(mktemp -d "$parent/.dotfiles-link.XXXXXX")
    ln -s "$path" "$staging/link"
    mv -f "$staging/link" "$destination"
    rmdir "$staging"
  fi
  touch -h "$destination"
done
