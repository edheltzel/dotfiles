# This "upp" function - Update Packages
# It is dependant on topgrade, brew, and node corepack
# sudo password is required via ~/.dotfiles/config/.config/topgrade.toml
# Usage: upp
#######################################

function upp {
  # Run topgrade
  topgrade

  # Run brew cleanup
  printf '\n―― %s - Brew - Cleanup ―――――――――――――――――――――――――――――――――――――――――――――――――――\n' $(date "+%H:%M:%S")
  brew cleanup --prune=all

  # Prepare pnpm and update
  printf '\n―― %s - pnpm - Corepack  ―――――――――――――――――――――――――――――――――――――――――――――――――\n' $(date "+%H:%M:%S")
  corepack prepare pnpm@latest --activate && pnpm update -g --latest
}
