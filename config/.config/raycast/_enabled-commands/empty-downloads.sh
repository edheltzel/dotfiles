#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Empty Downloads
# @raycast.mode inline
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 🗑️

# Documentation:
# @raycast.description Move all files in ~/Downloads to the Trash.
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

mv ~/Downloads/* ~/.Trash/
