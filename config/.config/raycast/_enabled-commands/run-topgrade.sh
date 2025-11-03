#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run Topgrade
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Terminal Utilities
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Update all packages
# @raycast.author edheltzel
# @raycast.authorURL https://raycast.com/edheltzel

# Application Mode: this will open a kitty window and run topgrade command
# open -a kitty
# sleep 1 # Wait for terminal to open
# osascript -e 'tell application "kitty" to activate'
# osascript -e 'tell application "System Events" to keystroke "topgrade"'
# osascript -e 'tell application "System Events" to key code 36' # Press Enter

# Quick Access Mode: this will open a kitty Quick Access window and run topgrade command
# osascript -e 'tell application "System Events" to keystroke "t" using {control down, option down, command down}'
# sleep 1                                                                 # Wait for quick access top open
# osascript -e 'tell application "System Events" to keystroke "topgrade"' # Run topgrade
# osascript -e 'tell application "System Events" to key code 36'          # Press Enter

# Application Mode: this will open a Wezterm window, create a new tab and run topgrade command
osascript -e 'tell application "System Events" to keystroke "t" using {shift down,control down, option down, command down}'
sleep 1                                                                               # Wait for quick access top open
osascript -e 'tell application "System Events" to keystroke "t" using {command down}' # Create new tab
osascript -e 'tell application "System Events" to keystroke "topgrade"'               # Run topgrade
osascript -e 'tell application "System Events" to key code 36'                        # Press Enter
