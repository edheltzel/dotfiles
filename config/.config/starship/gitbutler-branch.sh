#!/usr/bin/env bash
# starship GitButler-aware branch segment. Always exits 0.
# Vendored from https://github.com/1stvamp/starship-gitbutler (Apache-2.0).

BUTLER_SYMBOL="⧓"
GIT_SYMBOL="🌿"

# Colour codes. Empty by default so sourced tests see plain text; main() fills
# them in for the live prompt (see setup_colors).
SYM_COLOR=""
TEXT_COLOR=""
RESET=""

# Reads `but status --json` on stdin, prints the butler segment:
# a coloured ⧓ followed by the applied stacks (or "workspace" when none).
render_butler() {
  local out
  out="$(jq -r '
    [ .stacks[]? | .branches[]? | select(.name != null)
      | .name + (if (.commits|length) > 0
                 then " ↑" + (.commits|length|tostring)
                 else "" end)
    ] | join(" | ")
  ' 2>/dev/null)"
  [ -z "$out" ] && out="workspace"
  printf '%s%s%s %s%s%s' "$SYM_COLOR" "$BUTLER_SYMBOL" "$RESET" "$TEXT_COLOR" "$out" "$RESET"
}

# Prints the gitbutler data dir for the current repo if present, else nothing.
gitbutler_dir() {
  local d
  d="$(git rev-parse --git-path gitbutler 2>/dev/null)" || return 0
  [ -d "$d" ] || return 0
  ( cd "$d" && pwd )
}

# Prints `🌿 <branch>` for a plain git repo (short sha when detached).
render_git() {
  local name
  name="$(git branch --show-current 2>/dev/null)"
  [ -z "$name" ] && name="$(git rev-parse --short HEAD 2>/dev/null)"
  [ -z "$name" ] && return 0
  printf '%s%s %s%s' "$TEXT_COLOR" "$GIT_SYMBOL" "$name" "$RESET"
}

# Queries the terminal background via OSC 11 and prints "dark" or "light" based
# on its luminance. Prints nothing if the terminal doesn't answer. Reads/writes
# the controlling terminal directly so it never touches the captured stdout.
query_bg_mode() {
  [ -e /dev/tty ] || return 0
  local old resp hex r g b lum
  old="$(stty -g < /dev/tty 2>/dev/null)" || return 0
  stty raw -echo < /dev/tty 2>/dev/null
  printf '\e]11;?\a' > /dev/tty 2>/dev/null
  IFS= read -r -d '' -t 0.1 resp < /dev/tty 2>/dev/null
  stty "$old" < /dev/tty 2>/dev/null
  case "$resp" in
    *rgb:*) ;;
    *) return 0 ;;
  esac
  hex="${resp#*rgb:}"
  r="${hex%%/*}"; hex="${hex#*/}"
  g="${hex%%/*}"; hex="${hex#*/}"
  b="${hex%%[!0-9a-fA-F]*}"
  r=$((16#${r:-0})); g=$((16#${g:-0})); b=$((16#${b:-0}))
  [ "$r" -gt 255 ] && r=$((r>>8))
  [ "$g" -gt 255 ] && g=$((g>>8))
  [ "$b" -gt 255 ] && b=$((b>>8))
  lum=$(( (r*299 + g*587 + b*114) / 1000 ))
  if [ "$lum" -lt 128 ]; then printf 'dark'; else printf 'light'; fi
}

# Resolves the terminal background mode, cached per-tty for the session. An
# explicit GITBUTLER_PROMPT_MODE (light|dark) wins and skips the query.
detect_bg_mode() {
  case "${GITBUTLER_PROMPT_MODE:-}" in
    light|dark) printf '%s' "$GITBUTLER_PROMPT_MODE"; return 0 ;;
  esac
  local root tty_id cache mode
  root="${XDG_CACHE_HOME:-$HOME/.cache}/starship-gitbutler"
  tty_id="$(ps -o tty= -p $$ 2>/dev/null | tr -d ' /')"
  [ -z "$tty_id" ] && tty_id="unknown"
  cache="$root/mode-$tty_id"
  if { IFS= read -r mode < "$cache"; } 2>/dev/null && [ -n "$mode" ]; then
    printf '%s' "$mode"; return 0
  fi
  mode="$(query_bg_mode)"
  [ -z "$mode" ] && mode="dark"
  { mkdir -p "$root" && printf '%s' "$mode" > "$cache"; } 2>/dev/null
  printf '%s' "$mode"
}

# Eldritch pink for the ⧓ and stack names, matching [git_branch] in starship.toml.
# Dark: #F265B5. Light: #E63F9B (eldritch-light ansi magenta).
setup_colors() {
  RESET=$'\e[0m'
  case "$(detect_bg_mode)" in
    light)
      SYM_COLOR=$'\e[38;2;230;63;155m'
      TEXT_COLOR=$'\e[38;2;230;63;155m'
      ;;
    *)
      SYM_COLOR=$'\e[38;2;242;101;181m'
      TEXT_COLOR=$'\e[38;2;242;101;181m'
      ;;
  esac
}

# Runs `but status --json`, bounded by a timeout so a hung `but` can't
# stall the prompt. Override this function in tests to stub `but`.
# Patched from upstream `--format json` (removed in GitButler CLI 0.22).
but_status_json() {
  if command -v timeout >/dev/null 2>&1; then
    timeout "${BUT_TIMEOUT:-2}" but status --json
  else
    but status --json
  fi
}

# Prints the butler segment for the given gitbutler dir, caching on REFRESH mtime.
cached_butler() {
  local gbdir="$1"
  local refresh="$gbdir/REFRESH"
  local mtime cache_root key cache_file cached_mtime cached_val val

  # GNU coreutils uses `stat -c %Y`; BSD/macOS uses `stat -f %m`.
  mtime="$(stat -c %Y "$refresh" 2>/dev/null || stat -f %m "$refresh" 2>/dev/null)"
  cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/starship-gitbutler"
  key="$(printf '%s' "$gbdir" | cksum | cut -d' ' -f1)"
  cache_file="$cache_root/$key"

  if [ -n "$mtime" ] && { IFS= read -r cached_mtime < "$cache_file"; } 2>/dev/null; then
    if [ "$cached_mtime" = "$mtime" ]; then
      cached_val="$(sed '1d' "$cache_file" 2>/dev/null)"
      printf '%s' "$cached_val"
      return 0
    fi
  fi

  val="$(but_status_json 2>/dev/null | render_butler)"
  if [ -n "$mtime" ]; then
    { mkdir -p "$cache_root" && printf '%s\n%s' "$mtime" "$val" > "$cache_file"; } 2>/dev/null
  fi
  printf '%s' "$val"
}

main() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  setup_colors
  local gb
  gb="$(gitbutler_dir)"
  if [ -n "$gb" ]; then
    cached_butler "$gb"
  else
    render_git
  fi
}

# Run main only when executed directly, not when sourced by tests.
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main
fi
