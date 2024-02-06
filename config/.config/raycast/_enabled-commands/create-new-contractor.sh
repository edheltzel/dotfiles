#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create New Contractor folder
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 🚸
# @raycast.argument1 { "type": "text", "placeholder": "contractor name" }

# Documentation:
# @raycast.description Create a new Contractor folder
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

cp -r ~/Dropbox\ \(RDM\)/Ed\ \Heltzel/Apps/Automator/NewContractor ~/Dropbox\ \(RDM\)/Company\ Info/Contractors/"$1"

open ~/Dropbox\ \(RDM\)/Company\ Info/Contractors/"$1"
echo "🚸 New Contractor folder created"
