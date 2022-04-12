#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create New Client folder
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 👥
# @raycast.argument1 { "type": "text", "placeholder": "client name" }

# Documentation:
# @raycast.description Create a new client folder
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

cp -r ~/RDM\ \Dropbox/Ed\ \Heltzel/Apps/Automator/NewClient ~/RDM\ \Dropbox/Clients/$1
open ~/RDM\ \Dropbox/Clients/$1
echo "👥 $1 client folder created"
