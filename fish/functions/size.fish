# Show directory size
function size
  # du -khsc $argv | sort -rn
  du -khsc $argv
end
