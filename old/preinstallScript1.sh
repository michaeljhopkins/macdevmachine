#!/usr/bin/env bash

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.zshrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git