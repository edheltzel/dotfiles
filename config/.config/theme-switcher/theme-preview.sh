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
    aura)
      echo -e "\033[38;2;162;119;255m████\033[0m Aura"
      echo ""
      echo -e "  \033[38;2;21;20;27m███\033[0m bg"
      echo -e "  \033[38;2;237;236;238m███\033[0m fg"
      echo -e "  \033[38;2;162;119;255m███\033[0m purple"
      echo -e "  \033[38;2;97;255;202m███\033[0m green"
      echo -e "  \033[38;2;130;226;255m███\033[0m cyan"
      echo -e "  \033[38;2;255;103;103m███\033[0m red"
      echo -e "  \033[38;2;255;202;133m███\033[0m orange"
      echo -e "  \033[38;2;246;148;255m███\033[0m pink"
      ;;
    eldritch)
      echo -e "\033[38;2;164;140;242m████\033[0m Eldritch"
      echo ""
      echo -e "  \033[38;2;33;35;55m███\033[0m bg"
      echo -e "  \033[38;2;235;250;250m███\033[0m fg"
      echo -e "  \033[38;2;164;140;242m███\033[0m purple"
      echo -e "  \033[38;2;55;249;153m███\033[0m green"
      echo -e "  \033[38;2;4;209;249m███\033[0m cyan"
      echo -e "  \033[38;2;242;108;117m███\033[0m red"
      echo -e "  \033[38;2;241;252;121m███\033[0m yellow"
      echo -e "  \033[38;2;247;198;127m███\033[0m orange"
      ;;
    eldritch-dusk)
      echo -e "\033[38;2;138;105;247m████\033[0m Eldritch Dusk"
      echo ""
      echo -e "  \033[38;2;240;243;244m███\033[0m bg"
      echo -e "  \033[38;2;30;32;41m███\033[0m fg"
      echo -e "  \033[38;2;138;105;247m███\033[0m purple"
      echo -e "  \033[38;2;56;255;159m███\033[0m green"
      echo -e "  \033[38;2;10;214;255m███\033[0m cyan"
      echo -e "  \033[38;2;251;91;102m███\033[0m red"
      echo -e "  \033[38;2;255;249;82m███\033[0m yellow"
      echo -e "  \033[38;2;255;175;77m███\033[0m orange"
      ;;
    rose-pine)
      echo -e "\033[38;2;196;167;231m████\033[0m Rosé Pine"
      echo ""
      echo -e "  \033[38;2;25;23;36m███\033[0m bg"
      echo -e "  \033[38;2;224;222;244m███\033[0m fg"
      echo -e "  \033[38;2;196;167;231m███\033[0m iris"
      echo -e "  \033[38;2;49;116;143m███\033[0m pine"
      echo -e "  \033[38;2;156;207;216m███\033[0m foam"
      echo -e "  \033[38;2;235;111;146m███\033[0m love"
      echo -e "  \033[38;2;246;193;119m███\033[0m gold"
      echo -e "  \033[38;2;235;188;186m███\033[0m rose"
      ;;
    rose-pine-moon)
      echo -e "\033[38;2;196;167;231m████\033[0m Rosé Pine Moon"
      echo ""
      echo -e "  \033[38;2;35;33;54m███\033[0m bg"
      echo -e "  \033[38;2;224;222;244m███\033[0m fg"
      echo -e "  \033[38;2;196;167;231m███\033[0m iris"
      echo -e "  \033[38;2;62;143;176m███\033[0m pine"
      echo -e "  \033[38;2;156;207;216m███\033[0m foam"
      echo -e "  \033[38;2;235;111;146m███\033[0m love"
      echo -e "  \033[38;2;246;193;119m███\033[0m gold"
      echo -e "  \033[38;2;234;154;151m███\033[0m rose"
      ;;
    rose-pine-dawn)
      echo -e "\033[38;2;144;122;169m████\033[0m Rosé Pine Dawn"
      echo ""
      echo -e "  \033[38;2;250;244;237m███\033[0m bg"
      echo -e "  \033[38;2;87;82;121m███\033[0m fg"
      echo -e "  \033[38;2;144;122;169m███\033[0m iris"
      echo -e "  \033[38;2;40;105;131m███\033[0m pine"
      echo -e "  \033[38;2;86;148;159m███\033[0m foam"
      echo -e "  \033[38;2;180;99;122m███\033[0m love"
      echo -e "  \033[38;2;234;157;52m███\033[0m gold"
      echo -e "  \033[38;2;215;130;126m███\033[0m rose"
      ;;
    tokyonight)
      echo -e "\033[38;2;187;154;247m████\033[0m Tokyo Night"
      echo ""
      echo -e "  \033[38;2;26;27;38m███\033[0m bg"
      echo -e "  \033[38;2;192;202;245m███\033[0m fg"
      echo -e "  \033[38;2;187;154;247m███\033[0m purple"
      echo -e "  \033[38;2;158;206;106m███\033[0m green"
      echo -e "  \033[38;2;122;162;247m███\033[0m blue"
      echo -e "  \033[38;2;247;118;142m███\033[0m red"
      echo -e "  \033[38;2;224;175;104m███\033[0m yellow"
      echo -e "  \033[38;2;255;158;100m███\033[0m orange"
      ;;
    tokyonight-moon)
      echo -e "\033[38;2;192;153;255m████\033[0m Tokyo Night Moon"
      echo ""
      echo -e "  \033[38;2;34;34;54m███\033[0m bg"
      echo -e "  \033[38;2;200;211;245m███\033[0m fg"
      echo -e "  \033[38;2;192;153;255m███\033[0m purple"
      echo -e "  \033[38;2;195;232;141m███\033[0m green"
      echo -e "  \033[38;2;130;170;255m███\033[0m blue"
      echo -e "  \033[38;2;255;117;127m███\033[0m red"
      echo -e "  \033[38;2;255;199;119m███\033[0m yellow"
      echo -e "  \033[38;2;255;150;108m███\033[0m orange"
      ;;
    vesper)
      echo -e "\033[38;2;255;207;168m████\033[0m Vesper"
      echo ""
      echo -e "  \033[38;2;16;16;16m███\033[0m bg"
      echo -e "  \033[38;2;204;204;204m███\033[0m fg"
      echo -e "  \033[38;2;125;125;125m███\033[0m comment"
      echo -e "  \033[38;2;255;128;128m███\033[0m red"
      echo -e "  \033[38;2;255;199;153m███\033[0m yellow"
      echo -e "  \033[38;2;255;207;168m███\033[0m orange"
      echo -e "  \033[38;2;130;217;194m███\033[0m green"
      echo -e "  \033[38;2;153;255;228m███\033[0m cyan"
      ;;
    catppuccin-latte)
      echo -e "\033[38;2;136;57;239m████\033[0m Catppuccin Latte"
      echo ""
      echo -e "  \033[38;2;239;241;245m███\033[0m bg"
      echo -e "  \033[38;2;76;79;105m███\033[0m fg"
      echo -e "  \033[38;2;136;57;239m███\033[0m mauve"
      echo -e "  \033[38;2;64;160;43m███\033[0m green"
      echo -e "  \033[38;2;30;102;245m███\033[0m blue"
      echo -e "  \033[38;2;210;15;57m███\033[0m red"
      echo -e "  \033[38;2;223;142;29m███\033[0m yellow"
      echo -e "  \033[38;2;254;100;11m███\033[0m peach"
      ;;
    catppuccin-frappe)
      echo -e "\033[38;2;202;158;230m████\033[0m Catppuccin Frappé"
      echo ""
      echo -e "  \033[38;2;48;52;70m███\033[0m bg"
      echo -e "  \033[38;2;198;208;245m███\033[0m fg"
      echo -e "  \033[38;2;202;158;230m███\033[0m mauve"
      echo -e "  \033[38;2;166;209;137m███\033[0m green"
      echo -e "  \033[38;2;140;170;238m███\033[0m blue"
      echo -e "  \033[38;2;231;130;132m███\033[0m red"
      echo -e "  \033[38;2;229;200;144m███\033[0m yellow"
      echo -e "  \033[38;2;239;159;118m███\033[0m peach"
      ;;
    catppuccin-macchiato)
      echo -e "\033[38;2;198;160;246m████\033[0m Catppuccin Macchiato"
      echo ""
      echo -e "  \033[38;2;36;39;58m███\033[0m bg"
      echo -e "  \033[38;2;202;211;245m███\033[0m fg"
      echo -e "  \033[38;2;198;160;246m███\033[0m mauve"
      echo -e "  \033[38;2;166;218;149m███\033[0m green"
      echo -e "  \033[38;2;138;173;244m███\033[0m blue"
      echo -e "  \033[38;2;237;135;150m███\033[0m red"
      echo -e "  \033[38;2;238;212;159m███\033[0m yellow"
      echo -e "  \033[38;2;245;169;127m███\033[0m peach"
      ;;
    catppuccin-mocha)
      echo -e "\033[38;2;203;166;247m████\033[0m Catppuccin Mocha"
      echo ""
      echo -e "  \033[38;2;30;30;46m███\033[0m bg"
      echo -e "  \033[38;2;205;214;244m███\033[0m fg"
      echo -e "  \033[38;2;203;166;247m███\033[0m mauve"
      echo -e "  \033[38;2;166;227;161m███\033[0m green"
      echo -e "  \033[38;2;137;180;250m███\033[0m blue"
      echo -e "  \033[38;2;243;139;168m███\033[0m red"
      echo -e "  \033[38;2;249;226;175m███\033[0m yellow"
      echo -e "  \033[38;2;250;179;135m███\033[0m peach"
      ;;
    dracula)
      echo -e "\033[38;2;189;147;249m████\033[0m Dracula"
      echo ""
      echo -e "  \033[38;2;40;42;54m███\033[0m bg"
      echo -e "  \033[38;2;248;248;242m███\033[0m fg"
      echo -e "  \033[38;2;189;147;249m███\033[0m purple"
      echo -e "  \033[38;2;80;250;123m███\033[0m green"
      echo -e "  \033[38;2;139;233;253m███\033[0m cyan"
      echo -e "  \033[38;2;255;85;85m███\033[0m red"
      echo -e "  \033[38;2;241;250;140m███\033[0m yellow"
      echo -e "  \033[38;2;255;121;198m███\033[0m pink"
      ;;
    gruvbox)
      echo -e "\033[38;2;250;189;47m████\033[0m Gruvbox Dark"
      echo ""
      echo -e "  \033[38;2;40;40;40m███\033[0m bg"
      echo -e "  \033[38;2;235;219;178m███\033[0m fg"
      echo -e "  \033[38;2;211;134;155m███\033[0m purple"
      echo -e "  \033[38;2;184;187;38m███\033[0m green"
      echo -e "  \033[38;2;131;165;152m███\033[0m blue"
      echo -e "  \033[38;2;251;73;52m███\033[0m red"
      echo -e "  \033[38;2;250;189;47m███\033[0m yellow"
      echo -e "  \033[38;2;254;128;25m███\033[0m orange"
      ;;
    *)
      echo "Unknown theme: $theme"
      return 1
      ;;
  esac
  
  echo ""
}

show_support() {
  local theme="$1"

  echo "Application Support:"
  echo ""

  echo "  ✓   ghostty"
  echo "  ✓   kitty"
  echo "  ✓   wezterm"
  if [[ "$theme" == "eldritch-dusk" ]]; then
    echo "  ✗   neovim (no dusk palette)"
  else
    echo "  ✓   neovim"
  fi
  echo "  ✓     bat"
  echo "  ✓     btop"
  echo "  ✓   starship"
  echo "  ✓   lazygit"
  echo "  ✓   claude"
  echo "  ✓ 󰳆  herdr"
  echo "  ✓   gh-dash"
  if [[ -f "$HOME/.dotfiles/config/.config/superfile/theme/${theme}.toml" ]]; then
    echo "  ✓ 󰉋  superfile"
  else
    echo "  ✗ 󰉋  superfile"
  fi
}

# Main
if [ -z "$theme" ]; then
  echo ""
  echo "No theme specified"
  echo ""
  echo "Available themes:"
  echo "  - eldritch"
  echo "  - eldritch-dusk"
  echo "  - tokyonight"
  echo "  - rose-pine"
  echo "  - rose-pine-dawn"
  echo "  - rose-pine-moon"
  echo "  - vesper"
  echo "  - catppuccin-latte"
  echo "  - catppuccin-frappe"
  echo "  - catppuccin-macchiato"
  echo "  - catppuccin-mocha"
  echo "  - dracula"
  echo "  - gruvbox"
  echo ""
  exit 0
fi

echo ""
show_colors "$theme"
echo ""
show_support "$theme"
echo ""
