#!/usr/bin/env bash
# starship GitButler-aware branch segment. Always exits 0.
# Vendored from https://github.com/1stvamp/starship-gitbutler (Apache-2.0).

BUTLER_SYMBOL="⧓"
GIT_SYMBOL="🌿"

# Colour codes stay empty; starship.toml paints [$output](pink).
SYM_COLOR=""
TEXT_COLOR=""
RESET=""

# Branch text is painted pink by starship. Counts use palette cyan/yellow/red.

# Prints "untracked tracked deleted" from but status JSON on stdin.
# added/untracked → untracked; deleted → deleted; everything else tracked
# (modified, renamed, or assigned to a stack). Duplicate paths count once.
count_changes() {
  jq -r '
    def kind:
      if .changeType == "added" or .changeType == "untracked" then "u"
      elif .changeType == "deleted" then "d"
      else "t" end;
    [ .uncommittedChanges[]?, (.stacks[]?.assignedChanges[]?)
      | select(type == "object" and .filePath != null) ]
    | unique_by(.filePath)
    | map(kind) as $k
    | "\($k | map(select(. == "u")) | length) \($k | map(select(. == "t")) | length) \($k | map(select(. == "d")) | length)"
  ' 2>/dev/null || printf '0 0 0'
}

# ↑N is commits on that applied branch, not commits ahead of upstream.
# +N is other applied stacks, omitted when there is only one.
# First stack's branches stay listed; extra stacks are a count only.
branch_text() {
  jq -r '
    (.stacks // []) as $s
    | [ $s[0].branches[]? | select(.name != null)
        | .name + (if (.commits|length) > 0 then " ↑" + (.commits|length|tostring) else "" end)
      ] | join(" | ") as $names
    | (if ($s|length) > 1 then " +" + (($s|length) - 1 | tostring) else "" end) as $extra
    | if $names == "" then "workspace" else $names + $extra end
  ' 2>/dev/null || printf 'workspace'
}

# "behind conflict". behind is upstreamState.behind (target), not branch ahead.
# conflict is 1 when an applied commit or the merge base is marked conflicted.
# No ahead, diverged, or uncommitted-file conflict field in this payload.
status_flags() {
  jq -r '
    def conflicted:
      any(.stacks[]?.branches[]?.commits[]?; .conflicted == true)
      or (.mergeBase.conflicted == true);
    "\(.upstreamState.behind // 0) \(if conflicted then 1 else 0 end)"
  ' 2>/dev/null || printf '0 0'
}

# behind/conflict glyphs. Empty when both are zero.
color_flags() {
  local behind conflict cr reset=$'\033[0m'
  read -r behind conflict <<<"${1:-0 0}"
  behind=${behind:-0}; conflict=${conflict:-0}
  [ "$behind" = 0 ] && [ "$conflict" = 0 ] && return 0
  cr="$(hex_ansi "$(palette_hex red)")"
  [ "$conflict" != 0 ] && printf ' %s%s' "$cr" "$reset"
  [ "$behind" != 0 ] && printf ' %s ×%s%s' "$cr" "$behind" "$reset"
}

emit_segment() {
  printf '%s%s%s %s%s%s%s%s' "$SYM_COLOR" "$BUTLER_SYMBOL" "$RESET" "$TEXT_COLOR" "$1" "$RESET" "$(color_flags "$3")" "$(color_counts "$2")"
}
palette_hex() {
  local key="$1" file p
  file="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  [ -f "$file" ] || return 0
  p="$(awk '/^palette[[:space:]]*=/ { p=$0; sub(/^[^=]*=[[:space:]]*/, "", p); gsub(/["'\'']/, "", p); print p; exit }' "$file")"
  [ -n "$p" ] || return 0
  awk -v p="$p" -v key="$key" '
    $0 == "[palettes." p "]" || $0 == "[palettes.\"" p "\"]" { inpal=1; next }
    inpal && /^\[/ { inpal=0 }
    inpal && $1 == key { gsub(/["# ]/, "", $3); print $3; exit }
  ' "$file"
}

hex_ansi() {
  local h="$1"
  [ "${#h}" -eq 6 ] || return 0
  printf '\033[38;2;%d;%d;%dm' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
}

# "u t d" → colored glyphs, empty when all zero.
color_counts() {
  local u t d cu ct cd reset=$'\033[0m'
  read -r u t d <<<"${1:-0 0 0}"
  u=${u:-0}; t=${t:-0}; d=${d:-0}
  [ "$u" = 0 ] && [ "$t" = 0 ] && [ "$d" = 0 ] && return 0
  cu="$(hex_ansi "$(palette_hex cyan)")"
  ct="$(hex_ansi "$(palette_hex yellow)")"
  cd="$(hex_ansi "$(palette_hex red)")"
  printf ' '
  [ "$u" != 0 ] && printf '%s ×%s%s ' "$cu" "$u" "$reset"
  [ "$t" != 0 ] && printf '%s ×%s%s ' "$ct" "$t" "$reset"
  [ "$d" != 0 ] && printf '%s ×%s%s ' "$cd" "$d" "$reset"
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
  local mtime cache_root key cache_file cached_mtime cached_branch cached_counts cached_flags val branch counts flags

  # GNU coreutils uses `stat -c %Y`; BSD/macOS uses `stat -f %m`.
  mtime="$(stat -c %Y "$refresh" 2>/dev/null || stat -f %m "$refresh" 2>/dev/null)"
  cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/starship-gitbutler-plain"
  key="$(printf '%s' "$gbdir" | cksum | cut -d' ' -f1)"
  cache_file="$cache_root/$key"

  if [ -n "$mtime" ] && { IFS= read -r cached_mtime < "$cache_file"; } 2>/dev/null; then
    cached_branch="$(sed -n '2p' "$cache_file" 2>/dev/null)"
    cached_counts="$(sed -n '3p' "$cache_file" 2>/dev/null)"
    cached_flags="$(sed -n '4p' "$cache_file" 2>/dev/null)"
    if [ "$cached_mtime" = "$mtime" ] && [ -n "$cached_counts" ] && [ -n "$cached_flags" ]; then
      emit_segment "$cached_branch" "$cached_counts" "$cached_flags"
      return 0
    fi
  fi

  val="$(but_status_json 2>/dev/null || true)"
  branch="$(printf '%s' "$val" | branch_text)"
  [ -z "$branch" ] && branch="workspace"
  counts="$(printf '%s' "$val" | count_changes)"
  flags="$(printf '%s' "$val" | status_flags)"
  [ -z "$counts" ] && counts="0 0 0"
  [ -z "$flags" ] && flags="0 0"
  if [ -n "$mtime" ]; then
    { mkdir -p "$cache_root" && printf '%s\n%s\n%s\n%s\n' "$mtime" "$branch" "$counts" "$flags" > "$cache_file"; } 2>/dev/null
  fi
  emit_segment "$branch" "$counts" "$flags"
}

main() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  local gb
  gb="$(gitbutler_dir)"
  if [ -n "$gb" ]; then
    cached_butler "$gb"
  else
    render_git
  fi
}

# Run main only when executed directly, not when sourced by tests.
if [ "${1:-}" = --self-check ]; then
  fixture='{"uncommittedChanges":[{"filePath":"a","changeType":"added"},{"filePath":"b","changeType":"modified"},{"filePath":"c","changeType":"deleted"}],"upstreamState":{"behind":3},"mergeBase":{"conflicted":null},"stacks":[{"assignedChanges":[{"filePath":"b","changeType":"modified"},{"filePath":"e","changeType":"renamed"}],"branches":[{"name":"feat","commits":[{},{"conflicted":true}]}]},{"branches":[{"name":"other","commits":[{}]}]},{"branches":[{"name":"third","commits":[]}]}]}'
  got="$(printf '%s' "$fixture" | count_changes)"
  [ "$got" = "1 2 1" ] || { printf 'counts failed: %s\n' "$got" >&2; exit 1; }
  got="$(printf '%s' "$fixture" | branch_text)"
  [ "$got" = "feat ↑2 +2" ] || { printf 'branch failed: %s\n' "$got" >&2; exit 1; }
  got="$(printf '%s' "$fixture" | status_flags)"
  [ "$got" = "3 1" ] || { printf 'flags failed: %s\n' "$got" >&2; exit 1; }
  exit 0
fi
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main
fi
