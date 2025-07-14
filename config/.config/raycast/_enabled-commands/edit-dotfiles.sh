#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Edit Dotfiles
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔩
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description Open Dotfiles in a new VSCdoe window
# @raycast.author edheltzel
# @raycast.authorURL https://raycast.com/edheltzel

nvim -n ~/.dotfiles
