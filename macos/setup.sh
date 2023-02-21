#!/usr/bin/env bash

##############################################################################
# Initiates the applying of MacOS-specific settings and preferences          #
# IMPORTANT: Be sure to read files through thoughouly before executing       #
#                                                                            #
# CAUTION: This script will apply changes to your OS X system configuration  #
# Be sure to read it through carefully, and remove anything you don't want.  #
# Close any open System Preferences panes, to prevent them from overriding   #
# settings we’re about to change                                             #
#                                                                            #
# This file is inspired by - https://mths.be/macos                           #
##############################################################################

#

DIR=$(dirname "$0")
cd "$DIR"

# Variables for system preferences
IS_MACBOOK=`system_profiler SPSoftwareDataType SPHardwareDataType | grep "Model Name" | grep "Book"`
if [ "$IS_MACBOOK" != "" ]; then
  COMPUTER_NAME="MacDaddy"
  else
  COMPUTER_NAME="BigMac"
fi

# echo "Computer name: $COMPUTER_NAME" # DEBUG

. ../scripts/functions.sh

info "Configuring macOS defaults..."

# Ask for the administrator password upfront
sudo -v

# # Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Set computer name
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"


# System Preferences
source $DIR/_01-preferences.sh
source $DIR/_02-desktop_screensaver.sh
source $DIR/_03-dock.sh
source $DIR/_04-spotlight.sh
source $DIR/_05-apps.sh
source $DIR/_06-energy.sh
source $DIR/_07-inputs.sh
source $DIR/_08-security.sh

success "All Done! macOS Defaults are set... Note that some of these changes require a logout/restart to take effect."
