#!/bin/sh
cp ~/macdevmachine/mac $HOME/mac
cp ~/macdevmachine/.laptop.local ~/.laptop.local
touch $HOME/laptop.log
chmod 777 $HOME/laptop.log
cd $HOME
chmod +x ~/mac
sh ~/mac 2>&1 | tee ~/laptop.log

mkdir ~/Scripts
cp ~/macdevmachine/serve.sh ~/Scripts/serve.sh
echo 'export PATH="$HOME/Scripts:$PATH"' >> ~/.zshrc