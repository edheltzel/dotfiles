###############################################################################
# Applies MacOS settings and preferences in /Library/Preferences             #
# Covers Spotlight, layout, colors, fonts, mouse, keyboard and shortcuts                                                             #
###############################################################################

# Store Identities in the KeyChain
sudo ssh-add -K

# Disable gatekeeper - Security for Installing apps
sudo spctl --master-disable

# Enable or Disable the sound effects on boot
# %00 = enable %01 = disable
sudo nvram StartupMute=%00

# Disable transparency in the menu bar and elsewhere on Yosemite
#defaults write com.apple.universalaccess reduceTransparency -bool true

# Appearance For Buttons, Menus, and Windows
# Blue     : 1 (default)
# Graphite : 6
defaults write NSGlobalDomain AppleAquaColorVariant -int 1

# Use dark menu bar and Dock
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Highlight color
# Red      : `1.000000 0.733333 0.721569`
# Orange   : `1.000000 0.874510 0.701961`
# Yellow   : `1.000000 0.937255 0.690196`
# Green    : `0.752941 0.964706 0.678431`
# Blue     : `0.847059 0.847059 0.862745` (default)
# Purple   : `0.968627 0.831373 1.000000`
# Pink     : `0.968627 0.831373 1.000000`
# Brown    : `0.929412 0.870588 0.792157`
# Graphite : `0.847059 0.847059 0.862745`
# Silver   : `0.776500 0.776500 0.776500` (custom)
defaults write NSGlobalDomain AppleHighlightColor -string '0.847059 0.847059 0.862745'
# Translucent menu bar - disabled in Yosemite
# defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Sidebar icon size
# Small  : 1
# Medium : 2 (default)
# Large  : 3
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2


# Show scroll bars
# Automatically based on mouse or trackpad : `Automatic`
# When scrolling                           : `WhenScrolling`
# Always                                   : `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string 'WhenScrolling'

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Set number of recent items (Documents, Apps, and Servers)
# PlistBuddy approach appears broken:
# RecentApplications, RecentDocuments, RecentServers
#/usr/libexec/PlistBuddy -x -c "Set :RecentApplications:MaxAmount 0" ~/Library/Preferences/com.apple.recentitems.plist
for category in 'applications' 'documents' 'servers'; do
  /usr/bin/osascript -e "tell application \"System Events\" to tell appearance preferences to set recent $category limit to 0"
done

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Close windows when quitting an application (default)
#defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
#sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Never go into computer sleep mode
#sudo systemsetup -setcomputersleep Off > /dev/null

# Disable Notification Center and remove the menu bar icon
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null <- does not work

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage
