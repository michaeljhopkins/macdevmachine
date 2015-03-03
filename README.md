mac dev script
=======================

Preface
--------------

This is gonna install a whole bunch of stuff on your computer. Theres a pretty good chance that you personally wont need everything. I'd advise making a fork, and then you could edit the `.laptop.local` file to alter the things it installs

Credit
--------------

There is quite literally a copy of Thoughtbot's [laptop](https://github.com/thoughtbot/laptop)'s script at the base of this. Many cheers to them.

How to install
--------------

Since git is likely not installed. Zip this repo up and place it in your home directory

Unfortunately I haven't figured out how to properly get oh-my-zsh installed automatically. So you need to do these things first manually

Execute the following commands one at a time
```shell
xcode-select --install
curl http://xquartz-dl.macosforge.org/SL/XQuartz-2.7.7.dmg -o /tmp/XQuartz.dmg
open /tmp/XQuartz.dmg
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.zshrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
```
Restart your machine (I'm sorry)

If PHP machine
```shell
mv php.laptop.local ~/.laptop.local
```
If non php machine
```shell
mv nophp.laptop.local ~/.laptop.local
```
Run the following script
```shell
sh ~/macdevmachine/installScript1.sh
```
Open *sublime text* (or your preferred editor) and open the file found in your home directory `.zshrc` or from terminal `nano ~/.zshrc`

Change line 8 to
```shell
ZSH_THEME="pygmalion"
```
Change line 48 to
```shell
plugins=(sudo sublime command-not-found cp web-search node npm pip nvm gem rake rbenv bundler ruby python brew brew-cask zsh-syntax-highlighting)
```
