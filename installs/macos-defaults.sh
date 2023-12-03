defaults write com.apple.screencapture location "~/Documents/screenshots"
killall SystemUIServer # set above default immediately

#defaults write com.apple.dock orientation left
#defaults write com.apple.dock autohide -bool true
#defaults write com.apple.dock persistent-apps -array

#defaults write com.apple.dock wvous-br-modifier -int 1

#killall Dock # set above dock defaults immediately

# Disable shortcut (double-fn by default) for enabling dictation
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0

# faster keyboard response
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
