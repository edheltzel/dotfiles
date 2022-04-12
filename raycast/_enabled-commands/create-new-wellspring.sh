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
cp -r ~/RDM\ \Dropbox/Ed\ \Heltzel/Apps/Automator/NewClient/Projects/NewProjectName ~/RDM\ \Dropbox/Clients/$1/Projects/"P$NOW(NEWPROJECT)"
open ~/RDM\ \Dropbox/Clients/$1/Projects/
echo "🗣️ New Wellspring folder created"
