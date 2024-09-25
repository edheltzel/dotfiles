function mkd --description 'Make a directory and cd into it includes the -p option'
  mkdir -p $argv; and cd $argv
end
