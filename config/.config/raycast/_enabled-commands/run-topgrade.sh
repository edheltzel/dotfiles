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

open -a kitty
sleep 1 # Wait for terminal to open
osascript -e 'tell application "kitty" to activate'
osascript -e 'tell application "System Events" to keystroke "topgrade"'
osascript -e 'tell application "System Events" to key code 36' # Press Enter
