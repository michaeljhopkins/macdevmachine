#!/usr/bin/env sh

#
# You can change the version by passing the "VERSION" environment variable
# eg, env VERSION=0.10 sh node_nvm.sh
# 

: ${VERSION:="stable"}

echo
echo Installing Node.js $VERSION with NVM
echo

curl https://raw.githubusercontent.com/creationix/nvm/v0.17.2/install.sh | bash

# Boilerplate to avoid the restart of ayour shell

if [ -z "$PROFILE" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    PROFILE="$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.zshrc" ]; then
    PROFILE="$HOME/.zshrc"
  elif [ -f "$HOME/.profile" ]; then
    PROFILE="$HOME/.profile"
  fi
fi
source $PROFILE

# Real stuff

nvm install $VERSION
nvm use $VERSION
nvm alias default $VERSION