function pfs -d "Return the current Finder selection"
  osascript 2>/dev/null -e '
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
      if item_index is less than item_count then set the_delimiter to "\n"
      if item_index is item_count then set the_delimiter to ""
      set output to output & ((item item_index of the_selection as alias)\'s POSIX path) & the_delimiter
    end repeat'
end
