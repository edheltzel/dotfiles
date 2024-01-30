function manp -d "Open a specified man page in Preview"
  if [ (count $argv) -gt 0 ]
    mandoc -T pdf (man -w $argv) | open -fa Preview
  else
    echo "No arguments given"
  end
end
