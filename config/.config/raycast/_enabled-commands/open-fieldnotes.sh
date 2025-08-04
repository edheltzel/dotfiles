#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title bun install --globalFieldNotes
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🌾
# @raycast.packageName Launch Apple Notes with FiledNotes Home Note
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Open Notes on the FieldNotes Home Note
# @raycast.author edheltzel
# @raycast.authorURL https://raycast.com/edheltzel

osascript <<EOD
tell application "Notes"
    activate
    try
        set noteToOpen to first note whose name is "✱✱ Field Notes"
        show noteToOpen
    on error
        # Fallback if note isn't found
        log "Note not found"
    end try
end tell
EOD
