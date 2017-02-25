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

Since git is likely not installed. Zip this repo up and place it in your home directory. If git is installed.
```shell
cd ~
git clone git@github.com:michaeljhopkins/macdevmachine.git
```

Execute the following commands one at a time
```shell
xcode-select --install
curl http://xquartz-dl.macosforge.org/SL/XQuartz-2.7.7.dmg -o /tmp/XQuartz.dmg
open /tmp/XQuartz.dmg
sh ~/macdevmachine/preinstallScript1.sh
```

Open *sublime text* (or your preferred editor) and open the file found in your home directory `.zshrc` or from terminal `nano ~/.zshrc`

```shell
subl ~/.zshrc
```

Change line 8 to
```shell
ZSH_THEME="pygmalion"
```
Change line 48 to
```shell
plugins=(sudo sublime command-not-found cp web-search node npm pip nvm gem rake rbenv bundler ruby python brew brew-cask zsh-syntax-highlighting)
```

Restart your machine (I'm sorry)

Is your terminal colored and rad like zsh should be? If not. Something didn't work correctly

Edit this file to alter which programs to install. The contents should be fairly self explanitory
```shell
subl ~/macdevmachine/.laptop.local
```

Run the following script
```shell
sh ~/macdevmachine/installScript1.sh
```

If you run into any errors during the execution of the above script, you **SHOULD** be able to simply rerun it after
addressing whatever the error was. But let me know about it anyways

TODO
--------------

* Only install IDE's relevant to the user based on shell prompts
* Figure out how to automate the very manual first part