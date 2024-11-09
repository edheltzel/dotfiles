#!/bin/sh

# Query yabai for window info
yabai_output=$(yabai -m query --windows app,title --window)

# Check if the output is empty
if [ -z "$yabai_output" ]; then
  # Output is empty, print "empty" to indicate no windows
  echo "empty"
else
  # Output is not empty, print the yabai output
  echo "$yabai_output"
fi
