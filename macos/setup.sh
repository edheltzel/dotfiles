#!/usr/bin/env bash
##############################################################################
# Initiates the applying of MacOS-specific settings and preferences          #
# IMPORTANT: Be sure to read files through thoughouly before executing       #
#                                                                            #
# CAUTION: This script will apply changes to your MacOS system configuration #
# Be sure to read it through carefully, and remove anything you don't want.  #
#                                                                            #
# Close any open System Preferences panes, to prevent them from overriding   #
# settings we’re about to change                                             #
#                                                                            #
# This file is inspired by - https:
##############################################################################
DIR=$(dirname "$0");
cd "$DIR";
###########################################################################################
# Variables for system preferences and settings                                           #
# NOTE: I use a multi Mac workflow, so I have to set the computer name based on the model #
###########################################################################################
IS_MACBOOK=`system_profiler SPSoftwareDataType SPHardwareDataType | grep "Model Name" | grep "Book"`;
if [ "$IS_MACBOOK" != "" ]; then
COMPUTER_NAME="MacDaddy";
else
COMPUTER_NAME="BigMac";
fi
# echo "Computer name: $COMPUTER_NAME" # DEBUG
. ../scripts/functions.sh;
info "Configuring macOS defaults...";
# Ask for the administrator password upfront
sudo -v;
# # Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &;
substep_info "Setting computer name to $COMPUTER_NAME";
sudo scutil --set ComputerName "$COMPUTER_NAME";
sudo scutil --set LocalHostName "$COMPUTER_NAME";
sudo scutil --set HostName "$COMPUTER_NAME";
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME";
substep_success "Computer name set to $COMPUTER_NAME";
substep_info "Setting MacOS System settings and preferences...";
source $DIR/01-preferences.sh;
source $DIR/02-apps.sh;
source $DIR/03-security.sh;
substep_success "✔ All tasks were completed";
echo -e "         .:'\n     __ :'__\n  .'\`__\`-'__\`\`.\n \
:__________.-'\n :_________:\n  :_________\`-;\n   \`.__.-.__.'"
success "Restart $COMPUTER_NAME for changes to take effect.";
