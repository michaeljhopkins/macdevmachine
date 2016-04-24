#!/bin/sh
brewTaps=(thoughtbot/formulae homebrew/services homebrew/dupes homebrew/versions homebrew/homebrew-php caskroom/homebrew-cask caskroom/versions homebrew/nginx caskroom/fonts)
brewPackages=(nvm php70 mcrypt php70-mcrypt mysql redis mongodb git nginx tree curl zsh imagemagick rbenv libyaml wget heroku-toolbelt)
casksPackages=(iterm2 alfred droplr dash flux google-chrome google-drive java phpstorm sequel-pro slack spotify sublime-text3 teamviewer transmit transmission vlc vagrant-manager tower)
composerPackages=("laravel/envoy" "laravel/installer" "fabpot/php-cs-fixer" "halleck45/phpmetrics" "pdepend/pdepend" "squizlabs/php_codesniffer" "sebastian/phpcpd" "phpmd/phpmd")
npmPackages=(grunt-cli ied gulp bower)

# Welcome to the thoughtbot laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

# Require a new Git API token
echo "We're about to use a whole hell of a lot of homebrew, which relies upon Git.  In order to download so much from the Git API without waiting, "
echo "you will need to provide a valid Git API Access Token.  You can obtain one here: https://github.com/settings/tokens/new \n\n"
echo "Token: "
export HOMEBREW_GITHUB_API_TOKEN=37b193ee8232b8e2f099c395c832c04cf656bb40

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

token="export HOMEBREW_GITHUB_API_TOKEN=37b193ee8232b8e2f099c395c832c04cf656bb40"
append_to_zshrc $token

fancy_echo "Updating Homebrew formulas ..."
brew update

fancy_echo "Installing Homebrew Packages ..."
for i in "${brewTaps[@]}"; do
  brew tap $i
done

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

git clone https://github.com/powerline/fonts
./fonts/install.sh

brew services restart redis

gem update --system

gem_install_or_update 'bundler'

fancy_echo "Configuring Bundler ..."
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))