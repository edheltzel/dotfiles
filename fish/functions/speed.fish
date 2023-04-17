# Defined in - @ line 0
# checks for option/flags and passes it to the alias
# if no options run with verbose option.

function speed --description 'alias speed=networkQuality'
  if count $argv > /dev/null #Checks for option
  command networkQuality $argv
  else
  command networkQuality -v #No option - run verbose
  end
end
