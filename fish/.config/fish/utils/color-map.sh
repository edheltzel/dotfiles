#!/bin/bash

# Set the test text
TEXT='gYw'
TEXT_COL="\033[m"
RESET='\033[0m'
BASE_BG_CODES=(40m 41m 42m 43m 44m 45m 46m 47m)
BASE_COLOR_NAMES=(black red green yellow blue magenta cyan white)
SWATCH_WIDTH=9
# Outputs the number of colors supported by your terminal emulator
function check_color_support () {
  echo -e "\n${TEXT_COL}Your terminal supports $(tput colors) colors."
}
# Prints main 16 colors
function color_map_16_bit () {
  echo -e "\n${TEXT_COL}16-Bit Pallete${RESET}\n"
  for BG in "${BASE_BG_CODES[@]}"; do printf ' \033[%s%*s\033[0m' "$BG" "$SWATCH_WIDTH" ""; done; echo
  for i in "${!BASE_BG_CODES[@]}"; do
    BG=${BASE_BG_CODES[$i]}
    COLOR_NAME=${BASE_COLOR_NAMES[$i]}
    TEXT_COLOR='1;30m'
    if [[ "$BG" == '40m' ]]; then
      TEXT_COLOR='1;37m'
    fi
    PADDING=$((SWATCH_WIDTH - ${#COLOR_NAME}))
    LEFT_PADDING=$((PADDING / 2))
    RIGHT_PADDING=$((PADDING - LEFT_PADDING))
    printf ' \033[%s\033[%s%*s%s%*s\033[0m' \
      "$TEXT_COLOR" "$BG" "$LEFT_PADDING" "" "$COLOR_NAME" "$RIGHT_PADDING" ""
  done; echo
  for BG in "${BASE_BG_CODES[@]}"; do printf ' \033[%s%*s\033[0m' "$BG" "$SWATCH_WIDTH" ""; done; echo
}
# Prints all 256 supported colors
function color_map_256_bit () {
  echo -e "\n${TEXT_COL}256-Bit Pallete${RESET}\n"
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' "$i" "$i"; (((i+3) % 18)) || printf '\e[0m\n'; done
  echo
}



check_color_support
color_map_16_bit
# Print the column headers
printf '\n                 %-7s %-7s %-7s %-7s %-7s %-7s %-7s %-7s\n' "${BASE_COLOR_NAMES[@]}"

# Loop through all the foreground colors
for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m';
do
  FG=${FGs// /}
  # Print the foreground color code and test text
  echo -en " $FGs \033[$FG  $TEXT  "
  # Loop through all the background colors and print the color codes
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
  do
    echo -en " \033[$FG\033[$BG  $TEXT  \033[0m";
  done
  echo;
done

color_map_256_bit
