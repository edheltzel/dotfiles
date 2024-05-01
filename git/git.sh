#!/bin/bash
DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

# Get computer name
computer_name=$(scutil --get ComputerName)

if [ "$computer_name" = "BigMac" ]; then
  symlink "$SOURCE/gitconfig-bigmac.local" "$DESTINATION/.gitconfig.local"
elif [ "$computer_name" = "MacDaddy" ]; then
  symlink "$SOURCE/gitconfig-macdaddy.local" "$DESTINATION/.gitconfig.local"
else
  echo "Unknown computer name: $computer_name"
  exit 1
fi
