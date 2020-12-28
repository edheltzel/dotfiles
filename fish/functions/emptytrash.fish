# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
function emptytrash
  for files in ~/.Trash/
      command sudo rm -rdfv $files
  end
end
