################################################################################
# Desktop & Screen Saver                                                       #
################################################################################

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg


# # Set Screen Savers
# defaults -currentHost write com.apple.screensaver moduleDict "
#   <dict>
#     <key>moduleName</key><string>Shell</string>
#     <key>path</key><string>/System/Library/Screen Savers/Drift.saver</string>
#     <key>type</key><integer>1</integer>
#   </dict>
# "

# # Start after 30 Minutes
# defaults -currentHost write com.apple.screensaver idleTime -int 1800

# # Show with clock (default)
# defaults -currentHost write com.apple.screensaver showClock -bool false
