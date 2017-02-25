#!/bin/sh
brewPackages=(redis git nginx tree curl zsh imagemagick rbenv nvm libyaml wget heroku-toolbelt pyenv-virtualenv pyenv-virtualenvwrapper)
casksPackages=(ngrok alfred droplr dash java phpstorm webstorm rubymine pycharm spotify teamviewer vlc)
composerPackages=("laravel/envoy" "laravel/installer" "fabpot/php-cs-fixer" "halleck45/phpmetrics" "pdepend/pdepend" "squizlabs/php_codesniffer" "sebastian/phpcpd" "phpmd/phpmd")
npmPackages=(grunt-cli ied gulp bower)

# Welcome to the thoughtbot laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

# Require a new Git API token
echo "We're about to use a whole hell of a lot of homebrew, which relies upon Git.  In order to download so much from the Git API without waiting, "
echo "you will need to provide a valid Git API Access Token.  You can obtain one here: https://github.com/settings/tokens/new \n\n"
echo "Token: "
export HOMEBREW_GITHUB_API_TOKEN=0ec94289216370fdee62b1d408f98de914ba4df0

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

sudo xcodebuild -license
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update
git clone https://github.com/michaeljhopkins/macdevmachine
brew cask install sublime-text
brew cask install google-chrome
brew install git curl zsh wget ffmpeg stow python
git clone https://github.com/tarjoilija/zgen
brewTaps=(thoughtbot/formulae homebrew/services homebrew/dupes homebrew/versions homebrew/homebrew-php caskroom/homebrew-cask caskroom/versions homebrew/nginx caskroom/fonts)
for tap in $brewTaps; do brew tap $tap; done
chsh -s /bin/zsh
git clone https://github.com/michaeljhopkins/dotfiles ~/.dotfiles
cd ~/.dotfiles
stow --target=$HOME zsh
cd
ln -s /Users/m/.dotfiles/.zshrc.d /Users/m/.zshrc.d
zsh


trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    fancy_echo "Updating %s ..." "$1"
    gem update "$@"
  else
    fancy_echo "Installing %s ..." "$1"
    gem install "$@"
    rbenv rehash
  fi
}

token="export HOMEBREW_GITHUB_API_TOKEN=37b193ee8232b8e2f099c395c832c04cf656bb40"
append_to_zshrc $token

fancy_echo "Updating Homebrew formulas ..."
brew update

for i in "${brewPackages[@]}"; do
  brew install $i
done

# casksPackages

fancy_echo "Installing casksPackages"
for i in "${casksPackages[@]}"; do
  brew cask install $i
done

fancy_echo "Installing composerPackages"
for i in "${composerPackages[@]}"; do
  composer global require $i
done

# npmPackages

fancy_echo "Installing npmPackages"
for i in "${npmPackages[@]}"; do
  npm install $i -g
done


nvm install v5

rbenv install 2.3.0

gem update --system

gem_install_or_update 'bundler'

fancy_echo "Configuring Bundler ..."
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))