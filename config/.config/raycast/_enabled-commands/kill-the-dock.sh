#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill the Dock
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/kill-the-dock.png
# @raycast.argument1 { "type": "text", "placeholder": "Enter sudo password", "secure": true }
# @raycast.packageName Kill the Dock

# Documentation:
# @raycast.description Restart the dock
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

password="$1"
killall Dock && echo "$password" | sudo -S killall -KILL appleeventsd
echo "Dock has been relaunched"

