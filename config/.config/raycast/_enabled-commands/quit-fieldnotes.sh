#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quit FieldNotes
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🚪
# @raycast.packageName Workflow Utilities
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Quit Notes and Reminders app at the same time
# @raycast.author edheltzel
# @raycast.authorURL https://raycast.com/edheltzel

osascript -e 'tell application "Notes" to quit'
osascript -e 'tell application "Reminders" to quit'
