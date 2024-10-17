#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill Window Server
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🪟
# @raycast.argument1 { "type": "text", "placeholder": "Enter sudo password", "secure": true }
# @raycast.packageName Kill Window Server

# Documentation:
# @raycast.description Restart the WindowServer on macOS
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

password="$1"
sudo /usr/bin/killall -KILL -HUP WindowServer && echo "$password"
echo "DONE"
