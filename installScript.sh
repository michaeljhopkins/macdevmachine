#!/bin/sh
xcode-select --install
curl http://xquartz-dl.macosforge.org/SL/XQuartz-2.7.7.dmg -o /tmp/XQuartz.dmg
open /tmp/XQuartz.dmg

cp .laptop.local ~/.laptop.local

curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log

cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/
echo 'alias composer="php /usr/bin/composer.phar"' >> ~/.zshrc && . ~/.zshrc

#I dunno if this is mac stuff that's good. People seem to like it
# https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716