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
brew install cirruslabs/cli/tart
brew install clang-format
brew install cmake
brew install diff-so-fancy
brew install eddieantonio/eddieantonio/imgcat
brew install gh
brew install jq
brew install noahgorstein/tap/jqp
brew install node
brew install tree
brew install watch

# Programming fonts
brew install --cask font-meslo-lg-nerd-font

# Utility fonts
brew install --cask font-shantell-sans

# Utility apps
brew install --cask itsycal
brew install --cask origami-studio
brew install --cask rectangle
brew install --cask stats
