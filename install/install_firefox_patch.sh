#!/bin/sh

for i in $(find -maxdepth 3 -type d -path "./.mozilla/firefox/*.*"); do
    cp -r ~/.dotfiles/files/firefox/chrome $i/chrome
done

sudo cp ~/.dotfiles/files/firefox/config.js /usr/lib/firefox