# Defined in - @ line 0
function upp --description 'work around for nvm to work with topgrade'
  node -v; and which node; topgrade
end
