# Defined in - @ line 0
function upp --description 'work around for nvm to work with topgrade'
  echo 'node version in use:';
  and node --version;
  and topgrade;
  echo; and echo -n '―― ';
  echo -n (date "+%H:%M:%S");
  echo -n ' - Brew - Cleanup ――――――――――――――――――――――――――――――――――――――――――――――――――――――';
  and brew cleanup --prune=all
end
