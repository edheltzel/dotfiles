function editssh --description 'Opens ssh known host file in the $EDITOR'
  eval $EDITOR ~/.ssh/known_hosts
end

function hostfile --description 'Opens macOS host file in the default $EDITOR'
  eval $EDITOR /Volumes/$VOL/private/etc/hosts
end
