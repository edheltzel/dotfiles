#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

# Check if Brewfile exists
if [ ! -f Brewfile ]; then
    error "Brewfile does not exist. Creating one with 'brew bundle dump'..."
    brew bundle dump
fi

# Prompt user to install packages from Brewfile
read -p "Do you want to install packages from Brewfile? (y/n)" choice
case "$choice" in
  y|Y )
    brew bundle install
    ;;
  n|N )
    success "Exiting without installing packages."
    ;;
  * )
    error "Invalid choice. Exiting without installing packages."
    ;;
esac
