#!/bin/sh
cp ~/macdevmachine/mac $HOME/mac
touch $HOME/laptop.log
chmod 777 $HOME/laptop.log
cd $HOME
chmod +x ~/mac
sh ~/mac 2>&1 | tee ~/laptop.log

cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
