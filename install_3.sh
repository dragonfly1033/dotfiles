#!/bin/bash


git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S picom-jonaburg-git ttf-raleway
cd ..

mkdir Pictures 
mv dotfiles/wallpapers Pictures
mv dotfiles/scripts .
mv dotfiles/.themes .
mv dotfiles/bin .
mv dotfiles/.profile .
mv dotfiles/.fehbg .
mv dotfiles/.config/* .config
mkdir -p /usr/local/share/fonts
mv dotfiles/fonts/MyFonts /usr/local/share/fonts