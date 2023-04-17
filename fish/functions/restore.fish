function restore --description "Restore a file from a .bak file"
  set original (echo $argv[1] | sed 's/\.bak$//')
  mv -- $argv[1] $original
end
