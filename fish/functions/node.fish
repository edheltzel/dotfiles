# -------------------------------------------------------------------
# Keeping the file around but using the Fisher plugin Update 
# https://github.com/publicarray/update  --> fisher publicarray/update
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Update Homebrew Packages, Gems, Node Packages and macOS apps
# -------------------------------------------------------------------
# function update 
# set message_color (set_color magenta)
# set message_color_clear (set_color normal)
#   echo -e $message_color "Checking for macOS updates..."$message_color_clear
#   sudo softwareupdate -i -a
#   echo -e $message_color "Checking for Homebrew updates..."$message_color_clear
#   brew update
#   brew upgrade --force --all
#   echo -e $message_color "Cleaning out Homebrew and Pruning..."$message_color_clear
#   brew cleanup 
#   brew prune
#   echo -e $message_color "Checking with the Doc..."$message_color_clear
#   brew doctor
#   echo -e $message_color "Checking for NPM Updates..."$message_color_clear
#   npm i -g npm
#   npm update -g
#   echo -e $message_color "Checking for Gem Updates..."$message_color_clear
#   sudo gem update --system
#   sudo gem update
#   echo -e $message_color "Checking for Fisher Updates..."$message_color_clear
#   fisher update
# end


# -------------------------------------------------------------------
# update homebrew packages
# -------------------------------------------------------------------
# function brewup --description 'Updates Homebrew and Packages'
# set message_color (set_color magenta)
# set message_color_clear (set_color normal)
#   echo -e $message_color "🍻 Updating Homebrew to the latest version..." $message_color_clear
#   brew update;
#   echo -e $message_color "Upgrading already-installed 🍺 Homebrew formulas..." $message_color_clear
#   brew upgrade;
#   echo -e $message_color "⤵ Cleaning up outdated versions from the 🍺 Homebrew cellar..." $message_color_clear
#   brew cleanup;
#   echo -e $message_color "✂ ️Homebrew Needs a little Prune..." $message_color_clear
#   brew prune;
#   echo -e $message_color "Checking with the Doctor..." $message_color_clear
#   brew doctor;
# end

# -------------------------------------------------------------------
# update global node packages
# -------------------------------------------------------------------
function nodeup --description 'Updates Global NPM Packages'
set message_color (set_color magenta)
set message_info (set_color white)
set message_color_clear (set_color normal)

  echo -e $message_color "Checking for outdated Node Packages..." $message_color_clear
  npm outdated -g --depth=0;
  read -p  'echo "Wanna update the outdated packages? (y/n):"' -l confirm
  switch $confirm
    case '' Y y
      npm i npm@latest -g;
      npm update -g --verbose;
      npm outdated -g --depth=0; 
      echo -e $message_info "Some Packages need to be updated manually... try running >> $message_color_clear $message_color npm i -g <package_name>" $message_color_clear
    case N n
      echo -e $message_color "OK...cya!"$message_color_clear
  end
end
