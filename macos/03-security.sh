##############################################################################
# Security improvements for Mac OS systems                                    #
# Covers Siri, firewall, account security, connections and network protocols #
##############################################################################

# Quit System Preferences before starting
osascript -e 'tell application "System Preferences" to quit'

# ######################################
# Disabling Siri and related features #
# ######################################

# Disable Ask Siri
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

#  Disable Siri voice feedback
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

# Disable Siri services (Siri and assistantd)
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: \
    https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi

# Disable "Do you want to enable Siri?" pop-up
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

# Hide Siri from menu bar
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

# Hide Siri from status menu
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

# Opt-out from Siri data collection
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

# Don't prompt user to report crashes, may leak sensitive info
defaults write com.apple.CrashReporter DialogType none

############################
# MacOS Firewall Security #
############################

# Prevent automatically allowing incoming connections to signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Enable application firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on firewall logging
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Will prompt user to allow network access even for signed apps
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Will prompt user to allow network access for downloaded apps
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Sending hangup command to socketfilterfw is required for changes to take effect
sudo pkill -HUP socketfilterfw

# Prevents quarantine from storing info about downloaded files as privacy risk
sudo spctl --master-disable

####################################
# Log In and User Account Security #
####################################

# Enforce system hibernation
sudo pmset -a destroyfvkeyonstandby 1

# Evict FileVault keys from memory
sudo pmset -a hibernatemode 25

# Set power settings (required when evicting FV keys)
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disables signing in as Guest from the login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO


####################################
# Prevent Unauthorized Connections #
####################################

# Disables Guest access to file shares over SMB
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable remote login (incoming SSH and SFTP connections)
echo 'yes' | sudo systemsetup -setremotelogin off

# Disable insecure TFTP service
sudo launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
sudo launchctl disable system/com.apple.telnetd

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

#########################################
# Disable Printers and Sharing Protocols #
#########################################

# Disable sharing of local printers with other computers
cupsctl --no-share-printers

# Disable printing from any address including the Internet
cupsctl --no-remote-any

# Disable remote printer administration
cupsctl --no-remote-admin

# Disable Captive portal
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

