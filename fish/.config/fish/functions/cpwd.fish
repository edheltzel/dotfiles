# Defined in - @ line 0
function cpwd --description 'pwd copied to clipboard'
  command pwd | tr -d '\n' | pbcopy; and echo 'pwd copied to clipboard';
end
