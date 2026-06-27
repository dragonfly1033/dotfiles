#!/bin/sh

echo "First create the profiles you want in 3 seconds"
sleep 1; echo "3"; sleep 1; echo "2"; sleep 1; echo "1"; sleep 1
firefox -P

echo "------------------------"
echo "PATCH FIREFOX"
echo "------------------------"

if pacman -Qe | grep -q firefox; then
    for i in $(find ~ -maxdepth 4 -type d -path "$HOME/.config/mozilla/firefox/*.*"); do
        cp -r ~/.dotfiles/files/firefox/chrome "$i"
        rm -rf "$i"/startupCache/*
        cat ~/.dotfiles/files/firefox/user.js >> "$i"/prefs.js
    done

    sudo cp -r ~/.dotfiles/files/firefox/defaults "/usr/lib/firefox"
    sudo cp ~/.dotfiles/files/firefox/config.js /usr/lib/firefox
    sudo cp ~/.dotfiles/files/firefox/config-prefs.js /usr/lib/firefox/defaults/pref
fi