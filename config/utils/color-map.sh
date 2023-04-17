#!/bin/bash

# Set the test text
TEXT='gYw'
TEXT_COL="\033[m"
RESET='\033[0m'
# Outputs the number of colors supported by your terminal emulator
function check_color_support () {
  echo -e "\n${TEXT_COL}Your terminal supports $(tput colors) colors."
}
# Prints main 16 colors
function color_map_16_bit () {
  echo -e "\n${TEXT_COL}16-Bit Pallete${RESET}\n"
  base_colors='40m 41m 42m 43m 44m 45m 46m 47m'
  for BG in $base_colors; do echo -en "$EINS \033[$BG       \033[0m"; done; echo
  for BG in $base_colors; do printf " \033[1;30m\033[%b  %b  \033[0m" $BG $BG; done; echo
  for BG in $base_colors; do echo -en "$EINS \033[$BG       \033[0m"; done; echo
}
# Prints all 256 supported colors
function color_map_256_bit () {
  echo -e "\n${TEXT_COL}256-Bit Pallete${RESET}\n"
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
  echo
}



check_color_support
color_map_16_bit
# Print the column headers
echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";

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
