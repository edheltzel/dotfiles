#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill Finder
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/kill-finder.png
# @raycast.argument1 { "type": "text", "placeholder": "Enter sudo password", "secure": true }
# @raycast.packageName Kill Finder

# Documentation:
# @raycast.description Restart Finder
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

password="$1"

killall Finder && echo "$password" | sudo -S killall -KILL appleeventsd

echo "Finder has been restarted"

