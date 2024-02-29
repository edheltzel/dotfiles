#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Flush DNS
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 💨
# @raycast.argument1 { "type": "text", "placeholder": "Enter sudo password", "secure": true }
# @raycast.packageName Flush DNS

# Documentation:
# @raycast.description Flush DNS cache using m-cli
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

password="$1"
m dns flush && echo "$password"
echo "DNS cache flushed"
