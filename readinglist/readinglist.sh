#!/usr/bin/env bash
#
# readinglist.sh - install the Safari Reading List -> FieldNotes LaunchAgent.
#
# The plist is generated here instead of stowed because launchd cannot expand
# $HOME or ~, and this public repo must not carry machine-specific paths.
# Idempotent: rewrites the plist and reloads the agent on every run.
#
# Usage: readinglist/readinglist.sh   (or: just readinglist)

set -euo pipefail

READINGLIST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -z "${DOTFILES_FUNCTIONS_LOADED:-}" ]; then
  # shellcheck source-path=SCRIPTDIR source=../scripts/functions.sh
  . "$READINGLIST_DIR/../scripts/functions.sh"
fi

readonly LABEL="com.ed.readinglist-notes"
readonly RL2NOTES_BIN="$HOME/.local/bin/rl2notes"
readonly STATE_DIR="$HOME/.local/state/rl2notes"
readonly LOG_FILE="$STATE_DIR/run.log"
readonly BOOKMARKS_PLIST="$HOME/Library/Safari/Bookmarks.plist"
readonly AGENT_PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
readonly RUN_INTERVAL=600
DOMAIN="gui/$(id -u)"
readonly DOMAIN

check_requirements() {
  local cmd
  for cmd in launchctl plutil; do
    command -v "$cmd" >/dev/null 2>&1 || {
      error "$cmd is required but not found."
      exit 1
    }
  done
  if [ ! -x "$RL2NOTES_BIN" ]; then
    error "$RL2NOTES_BIN missing. Stow the package first: just stow readinglist"
    exit 1
  fi
}

# Full Disk Access is granted to a specific interpreter, so pin Homebrew's
# python3 rather than whatever python3 is first on PATH.
resolve_python() {
  local prefix
  if [ -n "${RL2NOTES_PYTHON:-}" ]; then
    PYTHON="$RL2NOTES_PYTHON"
  elif command -v brew >/dev/null 2>&1; then
    prefix="$(brew --prefix)"
    PYTHON="$prefix/bin/python3"
  else
    error "Homebrew not found; set RL2NOTES_PYTHON to the python3 to use."
    exit 1
  fi
  if [ ! -x "$PYTHON" ]; then
    error "$PYTHON is not executable. Install it with: brew install python3"
    exit 1
  fi
}

# Path to grant in System Settings > Privacy & Security > Full Disk Access.
python_app_path() {
  "$PYTHON" -c 'import os, sys; print(os.path.realpath(os.path.join(sys.base_prefix, "Resources", "Python.app")))'
}

write_plist() {
  local tmp
  mkdir -p "$STATE_DIR" "$(dirname "$AGENT_PLIST")"
  tmp="$(mktemp)"
  cat >"$tmp" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$PYTHON</string>
    <string>$RL2NOTES_BIN</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$BOOKMARKS_PLIST</string>
  </array>
  <key>StartInterval</key>
  <integer>$RUN_INTERVAL</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$LOG_FILE</string>
  <key>StandardErrorPath</key>
  <string>$LOG_FILE</string>
</dict>
</plist>
PLIST
  if ! plutil -lint -s "$tmp"; then
    rm -f "$tmp"
    error "Generated plist failed plutil -lint."
    exit 1
  fi
  mv "$tmp" "$AGENT_PLIST"
  chmod 644 "$AGENT_PLIST"
  substep_success "Wrote $AGENT_PLIST"
}

# Without state, the first run would re-save every Reading List item already
# synced into the vault from another Mac, so record them as seen first.
seed_state() {
  if [ -f "$STATE_DIR/seen.json" ]; then
    return 0
  fi
  substep_info "No rl2notes state yet; seeding current Reading List items as seen"
  if ! "$PYTHON" "$RL2NOTES_BIN" --seed; then
    error "Seeding failed (likely no Full Disk Access for this terminal). Grant it, then re-run: just readinglist"
    exit 1
  fi
}

load_agent() {
  local _
  if launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1; then
    launchctl bootout "$DOMAIN/$LABEL" || true
    # bootout returns before teardown finishes; bootstrapping too early fails with EIO.
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1 || break
      sleep 0.5
    done
  fi
  launchctl bootstrap "$DOMAIN" "$AGENT_PLIST"
  launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1 || {
    error "$LABEL did not load. Check: launchctl print $DOMAIN/$LABEL"
    exit 1
  }
  substep_success "Loaded $LABEL"
}

main() {
  info "Installing Safari Reading List -> FieldNotes agent ($LABEL)"
  check_requirements
  resolve_python
  seed_state
  write_plist
  load_agent
  warning "Full Disk Access required for: $(python_app_path) (re-grant after every Homebrew Python upgrade). Log: $LOG_FILE"
}

main "$@"
