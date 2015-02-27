mac dev script
=======================

How to install
--------------

* Clone this repository to your home directory:

    cd ~ && git clone git://github.com/michael-hopkins/macdevmachine.git
    cd macdevmachine
        
* If PHP machine

    mv php.laptop.local ~/.laptop.local
    
* If non php machine

    mv laptop.local ~/.laptop.local
    
* Run the install scripts

    sudo sh installScript1.sh
    sudo sh installScript2.sh
        
        nano ~/.zshrc
        
* make the following changes

Change line 8 to

    ZSH_THEME="pygmalion"

Change line 48 to

    plugins=(sudo sublime command-not-found cp web-search node npm pip nvm gem rake rbenv bundler ruby python brew brew-cask zsh-syntax-highlighting )
