# Defined in - @ line 0
function upp --description 'work around for nvm to work with topgrade'
  echo 'node version in use:'; and node --version; and topgrade; and brew cleanup --prune=all
end
