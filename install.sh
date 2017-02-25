#!/bin/sh

casksPackages=(sublime-text google-chrome spotify disk-inventory-x iterm2 shiftit skype jetbrains-toolbox alfred)
composerPackages=("laravel/installer" "laravel/valet" "fabpot/php-cs-fixer")
npmPackages=(yarn)

# Welcome to the thoughtbot laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

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

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

update_shell() {
  local shell_path;
  shell_path="$(which zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  chsh -s "$shell_path"
}

case "$SHELL" in
  */zsh)
    if [ "$(which zsh)" != '/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
    rbenv rehash
  fi
}

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF
tap "thoughtbot/formulae"
tap "homebrew/services"
tap "homebrew/php"
tap "homebrew/dupes"
tap "homebrew/versions"

# Unix
brew "git"
brew "openssl"
brew "tmux"
brew "zsh"
brew "stow"

# Heroku
brew "heroku-toolbelt"

# Image manipulation
brew "imagemagick"

# Testing
brew "qt"

# Programming languages
brew "libyaml" # should come after openssl
brew "nvm"
brew "rbenv"
brew "ruby-build"
brew "pyenv-virtualenv"
brew "pyenv-virtualenvwrapper"

brew "php70"
brew "composer"

brew "grc"
brew "libxml2"
brew "pyenv"
brew "wget"
brew "coreutils"
brew "curl"
brew "libpng"
brew "dnsmasq"

# Databases
brew "postgres", restart_service: true
brew "redis", restart_service: true
EOF

fancy_echo "Configuring Ruby ..."
find_latest_ruby() {
  rbenv install -l | grep -v - | tail -1 | sed -e 's/^ *//'
}

ruby_version="$(find_latest_ruby)"
# shellcheck disable=SC2016
eval "$(rbenv init -)"

if ! rbenv versions | grep -Fq "$ruby_version"; then
  RUBY_CONFIGURE_OPTS=--with-openssl-dir=/usr/local/opt/openssl rbenv install -s "$ruby_version"
fi

rbenv global "$ruby_version"
rbenv shell "$ruby_version"
gem update --system
gem_install_or_update 'bundler'
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

rm ~/.zshrc
git clone https://github.com/michaeljhopkins/dotfiles ~/.dotfiles
git clone https://github.com/tarjoilija/zgen
cd ~/.dotfiles
stow target=$HOME zsh
nvm install latest
nvm use latest
export HOMEBREW_GITHUB_API_TOKEN=0ec94289216370fdee62b1d408f98de914ba4df0
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

~/.composer/vendor/laravel/valet/valet install

mkdir ~/Projects
mkdir ~/Projects/Web
cd ~/Projects/Web
valet park