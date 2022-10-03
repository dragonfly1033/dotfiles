#!/bin/bash

cd ~
mkdir Pictures 
mv -r dotfiles/wallpapers Pictures
mv -r dotfiles/scripts .
mv -r dotfiles/.themes .
mv -r dotfiles/bin .
mv -r dotfiles/.config/* .config
mkdir -p /usr/local/share/fonts
mv -r dotfiles/fonts/MyFonts /usr/local/share/fonts
pacman -S ttf-raleway ttf-iosevka-nerd 
