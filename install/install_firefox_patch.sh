#!/bin/sh

username=$(whoami)

for i in $(find ~ -maxdepth 3 -type d -path "/home/$username/.mozilla/firefox/*.*"); do
    cp -r ~/.dotfiles/files/firefox/chrome $i/chrome
    sed -r "s!XXXXX!file://$i/chrome/resources/userChrome.css!" -i "$i/chrome/userChrome.css"
done

# find ~ -maxdepth 3 -type d -path "*/.mozilla/firefox/*.*" -exec cp -r ~/.dotfiles/files/firefox/chrome "{}"/chrome \;

sudo cp ~/.dotfiles/files/firefox/config.js /usr/lib/firefox