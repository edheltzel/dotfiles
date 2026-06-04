# Defined in - @ line 0
function yp --description 'pwd yanked to clipboard '
    command pwd | tr -d '\n' | pbcopy; and echo 'pwd yanked to clipboard'

end
