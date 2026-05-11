#!/usr/bin/env bash
# Theme switcher for dotfiles
# Switches themes across multiple applications

set -e

THEMES_DIR="$HOME/.config/theme-switcher"
DOTFILES="$HOME/.dotfiles"
CONFIG="$DOTFILES/config/.config"
# Available themes
THEMES=("aura" "eldritch" "rose-pine" "rose-pine-dawn" "rose-pine-moon" "tokyo-night" "tokyo-night-moon" "vesper")

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#------------------------------------------------------------------------------
# Helper Functions
#------------------------------------------------------------------------------

info() {
  echo -e "${BLUE}INFO:${NC} $1"
}

success() {
  echo -e "${GREEN}✓${NC} $1"
}

warning() {
  echo -e "${YELLOW}WARNING:${NC} $1"
}

error() {
  echo -e "${RED}ERROR:${NC} $1" >&2
  exit 1
}

#------------------------------------------------------------------------------
# Theme Name Mappings
#------------------------------------------------------------------------------

get_ghostty_theme() {
  case "$1" in
  aura) echo "aura" ;;
  eldritch) echo "config-file" ;;
  rose-pine) echo "Rose Pine" ;;
  rose-pine-dawn) echo "Rose Pine Dawn" ;;
  rose-pine-moon) echo "Rose Pine Moon" ;;
  tokyo-night) echo "TokyoNight" ;;
  tokyo-night-moon) echo "TokyoNight Moon" ;;
  vesper) echo "Vesper" ;;
  esac
}

get_kitty_theme() {
  case "$1" in
  aura) echo "eldritch-neoed.conf" ;; # Use eldritch as fallback
  eldritch) echo "eldritch-neoed.conf" ;;
  rose-pine) echo "rose-pine.conf" ;;
  rose-pine-dawn) echo "rose-pine-dawn.conf" ;;
  rose-pine-moon) echo "rose-pine-moon.conf" ;;
  tokyo-night) echo "" ;;      # Skip
  tokyo-night-moon) echo "" ;; # Skip
  vesper) echo "vesper.conf" ;;
  esac
}

get_wezterm_theme() {
  case "$1" in
  aura) echo "Aura" ;;
  eldritch) echo "Eldritch" ;;
  rose-pine) echo "rose-pine" ;;
  rose-pine-dawn) echo "rose-pine-dawn" ;;
  rose-pine-moon) echo "rose-pine-moon" ;;
  tokyo-night) echo "Tokyo Night" ;;
  tokyo-night-moon) echo "Tokyo Night Moon" ;;
  vesper) echo "vesper" ;;
  esac
}

get_neovim_theme() {
  case "$1" in
  aura) echo "aura-dark" ;;
  eldritch) echo "eldritch" ;;
  rose-pine) echo "rose-pine" ;;
  rose-pine-dawn) echo "rose-pine-dawn" ;;
  rose-pine-moon) echo "rose-pine-moon" ;;
  tokyo-night) echo "tokyonight-night" ;;
  tokyo-night-moon) echo "tokyonight-moon" ;;
  vesper) echo "vesper" ;;
  esac
}

get_bat_theme() {
  case "$1" in
  aura) echo "aura" ;;
  eldritch) echo "eldritch" ;;
  rose-pine) echo "rose-pine" ;;
  rose-pine-dawn) echo "rose-pine-dawn" ;;
  rose-pine-moon) echo "rose-pine-moon" ;;
  tokyo-night) echo "tokyonight_night" ;;
  tokyo-night-moon) echo "tokyonight_moon" ;;
  vesper) echo "vesper" ;; # Custom tmTheme
  esac
}

get_btop_theme() {
  case "$1" in
  aura) echo "eldritch" ;; # Use eldritch as fallback
  eldritch) echo "eldritch" ;;
  rose-pine) echo "rose-pine" ;;
  rose-pine-dawn) echo "rose-pine-dawn" ;;
  rose-pine-moon) echo "rose-pine-moon" ;;
  tokyo-night) echo "" ;;      # Skip
  tokyo-night-moon) echo "" ;; # Skip
  vesper) echo "vesper" ;;     # Custom theme file
  esac
}

get_claude_theme() {
  case "$1" in
  eldritch) echo "custom:eldritch" ;;
  vesper) echo "custom:vesper" ;;
  *) echo "" ;; # Skip — no custom theme JSON authored yet
  esac
}

#------------------------------------------------------------------------------
# Update Functions
#------------------------------------------------------------------------------

update_ghostty() {
  local theme="$1"
  local ghostty_theme=$(get_ghostty_theme "$theme")
  local config_file="$CONFIG/ghostty/config"

  if [[ "$theme" == "eldritch" ]]; then
    # Use custom config file for Eldritch
    sed -i '' 's/^theme = /#theme = /' "$config_file"
    sed -i '' 's/^#config-file = "colors\/eldritch"/config-file = "colors\/eldritch"/' "$config_file"
    success "Ghostty → eldritch (custom file)"
  else
    # Use built-in theme
    sed -i '' 's/^config-file = /#config-file = /' "$config_file"
    sed -i '' "s/^.*theme = .*/theme = $ghostty_theme/" "$config_file"
    success "Ghostty → $ghostty_theme"
  fi
}

update_kitty() {
  local theme="$1"
  local kitty_theme=$(get_kitty_theme "$theme")
  local config_file="$CONFIG/kitty/kitty.conf"

  if [[ -z "$kitty_theme" ]]; then
    warning "Kitty → skipped (theme not available)"
    return
  fi

  # Update the include line within the BEGIN_KITTY_THEME block
  sed -i '' "s|^include ./themes/.*\.conf|include ./themes/$kitty_theme|" "$config_file"

  if [[ "$theme" == "aura" ]]; then
    success "Kitty → $kitty_theme (eldritch fallback)"
  else
    success "Kitty → $kitty_theme"
  fi
}

update_wezterm() {
  local theme="$1"
  local wezterm_theme=$(get_wezterm_theme "$theme")
  local config_file="$CONFIG/wezterm/theme.lua"

  sed -i '' "s/^M\.name = .*/M.name = \"$wezterm_theme\"/" "$config_file"
  success "WezTerm → $wezterm_theme"
}

update_neovim() {
  local theme="$1"
  local nvim_theme=$(get_neovim_theme "$theme")
  local config_file="$DOTFILES/neoed/.config/nvim/lua/plugins/ui/colorscheme.lua"

  sed -i '' "s/colorscheme = \".*\"/colorscheme = \"$nvim_theme\"/" "$config_file"
  success "Neovim → $nvim_theme"
}

update_bat() {
  local theme="$1"
  local bat_theme=$(get_bat_theme "$theme")
  local config_file="$CONFIG/bat/config"

  if [[ -z "$bat_theme" ]]; then
    warning "bat → skipped (theme not available)"
    return
  fi

  sed -i '' "s/--theme=\".*\"/--theme=\"$bat_theme\"/" "$config_file"
  success "bat → $bat_theme"
}

update_btop() {
  local theme="$1"
  local btop_theme=$(get_btop_theme "$theme")
  local config_file="$CONFIG/btop/btop.conf"

  if [[ -z "$btop_theme" ]]; then
    warning "btop → skipped (theme not available)"
    return
  fi

  sed -i '' "s/color_theme = \".*\"/color_theme = \"$btop_theme\"/" "$config_file"

  if [[ "$theme" == "aura" ]]; then
    success "btop → $btop_theme (eldritch fallback)"
  else
    success "btop → $btop_theme"
  fi
}

update_lazygit() {
  local theme="$1"
  local config_file="$CONFIG/lazygit/config.yml"
  local theme_file="$THEMES_DIR/lazygit/${theme}.yml"

  if [[ ! -f "$theme_file" ]]; then
    warning "lazygit → skipped (theme snippet not found)"
    return
  fi

  # Find the start and end of the gui.theme block
  # Use awk to replace the entire gui.theme block
  awk -v theme_file="$theme_file" '
    /^gui:/ { in_gui=1; print; next }
    in_gui && /^  theme:/ { 
      in_theme=1
      while ((getline line < theme_file) > 0) {
        print line
      }
      close(theme_file)
      next
    }
    in_theme && /^  [a-z]/ { in_theme=0; in_gui=0 }
    in_theme { next }
    { print }
  ' "$config_file" >"$config_file.tmp" && mv "$config_file.tmp" "$config_file"

  success "lazygit → $theme"
}

update_claude() {
  local theme="$1"
  local claude_theme=$(get_claude_theme "$theme")
  local config_file="$HOME/.claude/settings.json"

  if [[ -z "$claude_theme" ]]; then
    warning "claude → skipped (no theme JSON for $theme)"
    return
  fi

  if [[ ! -e "$config_file" ]]; then
    warning "claude → skipped (settings.json not found)"
    return
  fi

  # Resolve symlinks — BSD sed -i refuses to edit through them
  local real_path
  if [[ -L "$config_file" ]]; then
    real_path=$(readlink "$config_file")
    [[ "$real_path" != /* ]] && real_path="$(cd "$(dirname "$config_file")" && cd "$(dirname "$real_path")" && pwd)/$(basename "$real_path")"
  else
    real_path="$config_file"
  fi

  sed -i '' "s|\"theme\": \"[^\"]*\"|\"theme\": \"$claude_theme\"|" "$real_path"
  success "claude → $claude_theme"
}

reload_ghostty() {
  # Ghostty requires manual reload - show message if running
  if ps aux | grep -q "[g]hostty"; then
    echo ""
    info "Ghostty: Press Cmd+Ctrl+Alt+, to reload config"
  fi
}

#------------------------------------------------------------------------------
# Main Logic
#------------------------------------------------------------------------------

show_current() {
  if [[ -f "$THEMES_DIR/current" ]]; then
    cat "$THEMES_DIR/current"
  else
    echo "Unknown"
  fi
}

list_themes() {
  local current_theme=$(show_current)
  echo "Available themes:"
  for theme in "${THEMES[@]}"; do
    if [[ "$theme" == "$current_theme" ]]; then
      echo "  ● $theme (current)"
    else
      echo "  - $theme"
    fi
  done
}

apply_theme() {
  local theme="$1"

  # Validate theme
  local valid=0
  for t in "${THEMES[@]}"; do
    if [[ "$t" == "$theme" ]]; then
      valid=1
      break
    fi
  done

  if [[ $valid -eq 0 ]]; then
    error "Invalid theme: $theme"
  fi

  echo ""
  info "Switching to theme: $theme"
  echo ""

  # Update all apps
  update_ghostty "$theme"
  update_kitty "$theme"
  update_wezterm "$theme"
  update_neovim "$theme"
  update_bat "$theme"
  update_btop "$theme"
  update_lazygit "$theme"
  update_claude "$theme"

  # Save current theme
  echo "$theme" >"$THEMES_DIR/current"

  echo ""
  success "Theme switched to: $theme"

  # Show reload instructions
  reload_ghostty

  echo ""
  info "Apps requiring restart: Neovim, WezTerm, Kitty, btop"
}

# Parse arguments
case "${1:-}" in
--current | -c)
  show_current
  ;;
--list | -l)
  list_themes
  ;;
--help | -h)
  echo "Usage: theme-switch.sh [THEME|--current|--list|--help]"
  echo ""
  echo "Switch color themes across all applications."
  echo ""
  echo "Options:"
  echo "  THEME           Apply specified theme"
  echo "  --current, -c   Show current theme"
  echo "  --list, -l      List available themes"
  echo "  --help, -h      Show this help message"
  echo ""
  echo "Available themes:"
  for theme in "${THEMES[@]}"; do
    echo "  - $theme"
  done
  ;;
"")
  # No argument - show fzf picker
  if ! command -v fzf &>/dev/null; then
    error "fzf is not installed. Please install it or provide a theme name."
  fi

  # Get current theme
  current_theme=$(show_current)

  # Build theme list with indicator for current theme
  theme_list=""
  for theme in "${THEMES[@]}"; do
    if [[ "$theme" == "$current_theme" ]]; then
      theme_list+="$theme (current)\n"
    else
      theme_list+="$theme\n"
    fi
  done

  selected=$(echo -e "$theme_list" | fzf \
    --height=50% \
    --reverse \
    --border \
    --header="Current: $current_theme" \
    --prompt="Select theme > " \
    --preview="$THEMES_DIR/theme-preview.sh {1}" \
    --preview-window=right:60% \
    --pointer="●" |
    awk '{print $1}')

  if [[ -n "$selected" ]]; then
    apply_theme "$selected"
  else
    info "No theme selected"
  fi
  ;;
*)
  # Theme name provided
  apply_theme "$1"
  ;;
esac
