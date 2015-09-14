#!/bin/sh
#
# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#
# Run ./defaults.sh and you'll be good to go.

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System                                                                       #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Set the dock icon sizes
#defaults write com.apple.dock magnification -bool true
#defaults write com.apple.dock tilesize -int 40
#defaults write com.apple.dock largesize -int 65

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Menu bar: hide the useless Time Machine and Volume icons
#defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Set the clock settings (System Preferences → Date & Time → Clock)
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm:ss"
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog -bool false

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Enable access for assistive devices
echo -n 'a' | sudo tee /private/var/db/.AccessibilityAPIEnabled > /dev/null 2>&1
sudo chmod 444 /private/var/db/.AccessibilityAPIEnabled

###############################################################################
# Expose / Hotcorners                                                       #
###############################################################################

# Faster expose animation times
defaults write com.apple.dock expose-animation-duration -float 0.20

# Disable animations for quick look
defaults write -g QLPanelAnimationDuration -float 0

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0

# Show desktop if we're in the top-left hot corner.
# defaults write com.apple.dock wvous-tl-corner -int 4
# defaults write com.apple.dock wvous-tl-modifier -int 0

###############################################################################
# Dock                                                                      #
###############################################################################

# Remove autohide dock delay
defaults write com.apple.Dock autohide-delay -float 0

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable auto-correct
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Mouse                                                                       #
###############################################################################

# Enable secondary click on mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"
# Make it right click - to use left click subsitute save.MouseButtonMode.v2 -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse save.MouseButtonMode.v1 -int 1

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Trackpad                                                                  #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Mail                                                                  #
###############################################################################

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

###############################################################################
# Finder                                                                    #
###############################################################################

# Save screenshots as JPEGs into a Desktop/Screenshots with no shadow
defaults write com.apple.screencapture location ~/Desktop/Screenshots
defaults write com.apple.screencapture type jpg
defaults write com.apple.screencapture disable-shadow -bool true

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Show hidden files
defaults write com.apple.Finder AppleShowAllFiles YES

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: use column view in all windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the ~/Library folder.
chflags nohidden ~/Library

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable text selection from quicklook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Always show the ~/Users/Library directory
chflags nohidden ~/Library/

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Skip DMG verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Add iOS Simulator to Launchpad
ln -s /Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications/iOS\ Simulator.app

###############################################################################
# Terminal                                                                    #
###############################################################################

# Set default Window to theme I like
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

###############################################################################
# Safari                                                                      #
###############################################################################

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# iTunes                                                                      #
###############################################################################

# Disable the iTunes store link arrows
defaults write com.apple.iTunes show-store-link-arrows -bool false

# Disable the Genius sidebar in iTunes
defaults write com.apple.iTunes disableGeniusSidebar -bool true

# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true

# Disable radio stations in iTunes
defaults write com.apple.iTunes disableRadio -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Transmission.app                                                            #
###############################################################################

echo "Setting up Transmission preferences"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Divvy.app                                                            #
###############################################################################

echo "Setting up Divvy shortcuts"
# Below sets the following shortcuts:
# Full Screen:          §
#-------------------------
# Left half:            1
#-------------------------
# Right half:           2
#-------------------------
# Top half:             3
#-------------------------
# Bottom half:          4
#-------------------------
# Top left 1/4:         Q
#-------------------------
# Top right 1/4:        W
#-------------------------
# Bottom left 1/4:      A
#-------------------------
# Bottom right 1/4:     S

defaults write com.mizage.Divvy shortcuts -data 62706c6973743030d40102030405087a7b5424746f7058246f626a65637473582476657273696f6e59246172636869766572d1060754726f6f748001af1016090a182e2f353d3e46474e4f55565d5e65666d6e757655246e756c6cd20b0c0d0e5624636c6173735a4e532e6f626a656374738015a90f10111213141516178002800580078009800b800d800f80118013dd191a1b1c1d1e1f20212223240b252627282626292a2b2a25292d5f101273656c656374696f6e456e64436f6c756d6e5f101173656c656374696f6e5374617274526f775c6b6579436f6d626f436f646557656e61626c65645d6b6579436f6d626f466c6167735f101473656c656374696f6e5374617274436f6c756d6e5b73697a65436f6c756d6e735a73756264697669646564576e616d654b657956676c6f62616c5f100f73656c656374696f6e456e64526f775873697a65526f777310051000100a0910060880030880045b46756c6c2053637265656ed2303132335824636c61737365735a24636c6173736e616d65a233345853686f7274637574584e534f626a656374dd191a1b1c1d1e1f20212223240b362637282626292a3a2a25292d1002101209088006088004594c6566742053696465dd191a1b1c1d1e1f20212223240b25263f282641292a432a25292d10130910030880080880045a52696768742053696465dd191a1b1c1d1e1f20212223240b362648282626292a4b2a36292d100c0908800a08800458546f70204c656674dd191a1b1c1d1e1f20212223240b364126282626292a522a25292d0908800c0880045b426f74746f6d204c656674dd191a1b1c1d1e1f20212223240b252657282641292a5a2a36292d100d0908800e08800459546f70205269676874dd191a1b1c1d1e1f20212223240b25415f282641292a622a25292d1001090880100880045c426f74746f6d205269676874dd191a1b1c1d1e1f20212223240b252667282626292a6a2a36292d10140908801208800458546f702068616c66dd191a1b1c1d1e1f20212223240b25416f282626292a722a25292d1015090880140880045b426f74746f6d2048616c66d230317778a37879345e4e534d757461626c654172726179574e53417272617912000186a05f100f4e534b657965644172636869766572000800110016001f002800320035003a003c0055005b0060006700720074007e00800082008400860088008a008c008e009000ab00c000d400e100e900f7010e011a0125012d01340146014f015101530155015601580159015b015c015e016a016f017801830186018f019801b301b501b701b801b901bb01bc01be01c801e301e501e601e801e901eb01ec01ee01f90214021602170218021a021b021d02260241024202430245024602480254026f0271027202730275027602780282029d029f02a002a102a302a402a602b302ce02d002d102d202d402d502d702e002fb02fd02fe02ff0301030203040310031503190328033003350000000000000201000000000000007c00000000000000000000000000000347
echo "useGlobalHotkey"
defaults write com.mizage.Divvy useGlobalHotkey -bool true
echo "globalHotkey"
defaults write com.mizage.Divvy globalHotkey -dict keyCode -string 10 modifiers -string 256

echo "Done. Note that some of these changes require a logout/restart to take effect."