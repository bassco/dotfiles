#!/bin/bash
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

echo "install omz and plugins"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/git-open
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

echo "Set iterm font and point size manually for now"
