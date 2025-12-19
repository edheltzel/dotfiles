#!/usr/bin/env bash
# Theme preview for fzf
# Shows color swatches and app support info

theme="$1"

# ANSI color codes
RESET='\033[0m'

# Define color swatches for each theme
show_colors() {
  local theme="$1"
  
  case "$theme" in
    eldritch)
      echo -e "\033[38;2;164;140;242m████\033[0m Eldritch"
      echo ""
      echo -e "\033[38;2;33;35;55m███\033[0m \033[38;2;235;250;250m███\033[0m \033[38;2;164;140;242m███\033[0m \033[38;2;55;249;153m███\033[0m \033[38;2;4;209;249m███\033[0m \033[38;2;242;108;117m███\033[0m \033[38;2;241;252;121m███\033[0m \033[38;2;247;198;127m███\033[0m"
      echo -e "bg   fg   purple green cyan  red   yellow orange"
      ;;
    rose-pine)
      echo -e "\033[38;2;196;167;231m████\033[0m Rosé Pine"
      echo ""
      echo -e "\033[38;2;25;23;36m███\033[0m \033[38;2;224;222;244m███\033[0m \033[38;2;196;167;231m███\033[0m \033[38;2;49;116;143m███\033[0m \033[38;2;156;207;216m███\033[0m \033[38;2;235;111;146m███\033[0m \033[38;2;246;193;119m███\033[0m \033[38;2;235;188;186m███\033[0m"
      echo -e "bg   fg   iris  pine  foam  love  gold  rose"
      ;;
    rose-pine-moon)
      echo -e "\033[38;2;196;167;231m████\033[0m Rosé Pine Moon"
      echo ""
      echo -e "\033[38;2;35;33;54m███\033[0m \033[38;2;224;222;244m███\033[0m \033[38;2;196;167;231m███\033[0m \033[38;2;62;143;176m███\033[0m \033[38;2;156;207;216m███\033[0m \033[38;2;235;111;146m███\033[0m \033[38;2;246;193;119m███\033[0m \033[38;2;234;154;151m███\033[0m"
      echo -e "bg   fg   iris  pine  foam  love  gold  rose"
      ;;
    tokyo-night)
      echo -e "\033[38;2;187;154;247m████\033[0m Tokyo Night"
      echo ""
      echo -e "\033[38;2;26;27;38m███\033[0m \033[38;2;192;202;245m███\033[0m \033[38;2;187;154;247m███\033[0m \033[38;2;158;206;106m███\033[0m \033[38;2;122;162;247m███\033[0m \033[38;2;247;118;142m███\033[0m \033[38;2;224;175;104m███\033[0m \033[38;2;255;158;100m███\033[0m"
      echo -e "bg   fg   purple green blue  red   yellow orange"
      ;;
    tokyo-night-moon)
      echo -e "\033[38;2;192;153;255m████\033[0m Tokyo Night Moon"
      echo ""
      echo -e "\033[38;2;34;34;54m███\033[0m \033[38;2;200;211;245m███\033[0m \033[38;2;192;153;255m███\033[0m \033[38;2;195;232;141m███\033[0m \033[38;2;130;170;255m███\033[0m \033[38;2;255;117;127m███\033[0m \033[38;2;255;199;119m███\033[0m \033[38;2;255;150;108m███\033[0m"
      echo -e "bg   fg   purple green blue  red   yellow orange"
      ;;
  esac
  
  echo ""
}

show_support() {
  local theme="$1"
  
  echo "Application Support:"
  echo ""
  
  # Full support
  echo "  ✓ ghostty"
  echo "  ✓ wezterm"
  echo "  ✓ neovim"
  echo "  ✓ bat"
  echo "  ✓ lazygit"
  echo "  ✓ oh-my-posh"
  
  # Conditional support
  case "$theme" in
    tokyo-night|tokyo-night-moon)
      echo "  ✗ kitty (not available)"
      echo "  ✗ btop (not available)"
      ;;
    *)
      echo "  ✓ kitty"
      echo "  ✓ btop"
      ;;
  esac
  
  case "$theme" in
    tokyo-night-moon)
      echo "  ✗ eza (not available)"
      ;;
    *)
      echo "  ✓ eza"
      ;;
  esac
}

# Main
echo ""
show_colors "$theme"
echo ""
show_support "$theme"
echo ""
