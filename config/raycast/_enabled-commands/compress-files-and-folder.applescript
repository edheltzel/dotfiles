#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Compress files and folder
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/zip-icon.png
# @raycast.packageName Compress

# Documentation:
# @raycast.description zip/compress the selected files and/or folders
# @raycast.author Ed Heltzel
# @raycast.authorURL https://github.com/edheltzel

tell application "System Events" to tell process "Finder"
	tell menu 1 of menu bar item 3 of menu bar 1
		click (menu item 1 where name starts with "Compress")
	end tell
end tell

