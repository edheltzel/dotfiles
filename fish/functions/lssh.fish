function lssh --description 'Quickly list all hosts in ssh config'
  command grep -w -i "Host" ~/.ssh/config | sed 's/Host//'
end

