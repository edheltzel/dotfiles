#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create New Wellspring folder
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 🗣️
# @raycast.argument1 { "type": "text", "placeholder": "client name" }

# Documentation:
# @raycast.description Create a new Wellspring folder
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

NOW=$(date +"%y%m%d")
cp -r ~/Google\ Drive/My\ Drive/Apps/Automator/NewClient/Developer/NewProjectName/ ~/Google\ Drive/Shared\ drives/Clients/"$1"/Developer/"P$NOW(NEWPROJECT)"
open ~/Google\ Drive/Shared\ drives/Clients/"$1"/Developer/
echo "🗣️ New Wellspring folder created"
