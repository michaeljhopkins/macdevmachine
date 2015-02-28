#!/bin/sh
curl --remote-name https://raw.githubusercontent.com/michael-hopkins/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log

cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

#I dunno if this is mac stuff that's good. People seem to like it
# https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
