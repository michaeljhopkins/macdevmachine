#!/bin/sh
brewTaps=(
  thoughtbot/formulae
  homebrew/services
  homebrew/dupes
  homebrew/versions
  homebrew/homebrew-php
  caskroom/homebrew-cask
  caskroom/versions
  homebrew/nginx
  caskroom/fonts
)
brewPackages=(
  php56
  mcrypt
  php56-mcrypt
  mysql
  redis
  mongodb
  git
  brew-cask
  nginx
  homebrew/apache/httpd24
  tree
  curl
  android-sdk
  zsh
  imagemagick
  rbenv
  ruby-build
  libyaml
  wget
)
casksPackages=(
  alfred
  dropbox
  droplr
  electric-sheep
  firefox
  flash
  flux
  google-chrome
  java
  phpstorm
  sequel-pro
  skype
  slack
  spotify
  sublime-text3
  teamviewer
  textexpander
  transmit
  transmission
  vlc
  adobe-creative-cloud
  vagrant-manager
  tower
)
brew_fonts=(
  font-source-code-pro
  font-anonymous-pro-for-powerline
  font-dejavu-sans-mono-for-powerline
  font-droid-sans-mono-for-powerline
  font-fira-mono-for-powerline
  font-inconsolata-dz-for-powerline
  font-inconsolata-for-powerline
  font-inconsolata-g-for-powerline
  font-liberation-mono-for-powerline
  font-meslo-lg-for-powerline
  font-sauce-code-powerline
  font-source-code-pro-for-powerline
  font-ubuntu-mono-powerline
)
composerPackages=(
  laravel/envoy
  laravel/installer
  fabpot/php-cs-fixer
  halleck45/phpmetrics
  pdepend/pdepend
  squizlabs/php_codesniffer
  sebastian/phpcpd
  phpmd/phpmd
)
npmPackages=(
  grunt-cli
  gulp
  bower
  nodemon
  sails
  protactor
  phantomjs
  forever
  phonegap
  cordova
  jade
  express
)

# Welcome to the thoughtbot laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

# Require a new Git API token
echo "We're about to use a whole hell of a lot of homebrew, which relies upon Git.  In order to download so much from the Git API without waiting, "
echo "you will need to provide a valid Git API Access Token.  You can obtain one here: https://github.com/settings/tokens/new \n\n"
echo "Token: "
read GIT_ACCESS_TOKEN
export HOMEBREW_GITHUB_API_TOKEN=$GIT_ACCESS_TOKEN

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

case "$SHELL" in
  */zsh) : ;;
  *)
    fancy_echo "Changing your shell to zsh ..."
      chsh -s "$(which zsh)"
    ;;
esac

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

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
  curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
  append_to_zshrc '# recommended by brew doctor'
  append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  append_to_zshrc 'export PATH="$HOME/.composer/vendor/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:$PATH"'
else
  fancy_echo "Homebrew already installed. Skipping ..."
fi

token = "export HOMEBREW_GITHUB_API_TOKEN=$GIT_ACCESS_TOKEN"
append_to_zshrc $token

fancy_echo "Updating Homebrew formulas ..."
brew update

# shellcheck disable=SC2016
append_to_zshrc 'eval "$(rbenv init - --no-rehash zsh)"' 1

fancy_echo "Installing nvm"
./nvm.sh

fancy_echo "Installing Homebrew Packages ..."
for i in "${brewTaps[@]}"; do
  brew tap $i
done

for i in "${brewPackages[@]}"; do
  brew install $i
done

append_to_zshrc "export PATH=\$(brew --prefix homebrew/php/php56)/bin:\$PATH"

# casksPackages

fancy_echo "Installing casksPackages"
for i in "${casksPackages[@]}"; do
  brew cask install $i
done

# composerPackages
if type composer > /dev/null; then
  fancy_echo 'Looks like you already have composer installed'
else
  fancy_echo "Installing Composer"
  #Install Composer and add to path
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

  echo "export PATH=\$HOME/.composer/vendor/bin:\$PATH" >> ~/.zshrc
  source ~/.zshrc
fi

fancy_echo "Installing composerPackages"
for i in "${composerPackages[@]}"; do
  composer global require $i
done

# npmPackages

fancy_echo "Installing npmPackages"
for i in "${npmPackages[@]}"; do
  npm install $i -g
done

# Install specified fonts
for font_name in ${brew_fonts[@]}; do
  echo "Installing ${app_name}…"
  brew cask install ${font_name}
done

brew services restart redis

ruby_version="$(curl -sSL http://ruby.thoughtbot.com/latest)"

eval "$(rbenv init - zsh)"

if ! rbenv versions | grep -Fq "$ruby_version"; then
  rbenv install -s "$ruby_version"
fi

rbenv global "$ruby_version"
rbenv shell "$ruby_version"

gem update --system

gem_install_or_update 'bundler'

fancy_echo "Configuring Bundler ..."
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))

if [ -f "$HOME/.laptop.local" ]; then
  . "$HOME/.laptop.local"
fi