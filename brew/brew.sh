#!/bin/sh
brew update
brew tap homebrew/cask
brew tap homebrew/cask-fonts

# Shell
brew install fish

# Setup fish as default
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

# Utilities
brew install clang-format
brew install cmake
brew install jq

# Programming fonts
brew install --cask font-meslo-lg-nerd-font

# Utility fonts
brew install --cask font-shantell-sans

# Utility apps
brew install --cask stats
brew install --cask rectangle
