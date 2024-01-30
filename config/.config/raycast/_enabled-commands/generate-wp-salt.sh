#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate WP Salt
# @raycast.mode compact

# Optional parameters:
# @raycast.icon images/wp-salt.png
# @raycast.packageName WordPress Salt

# Documentation:
# @raycast.description Generate a fresh WP Salt
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

curl https://api.wordpress.org/secret-key/1.1/salt/ | pbcopy
echo "🧂 New WP Salt copied to clipboard"

