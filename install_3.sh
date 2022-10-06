#!/bin/bash


git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null
yay -S --noconfirm --needed picom-jonaburg-git ttf-raleway > /dev/null
cd ..

mkdir Pictures
mv dotfiles/wallpapers Pictures
mv dotfiles/scripts .
mv dotfiles/.themes .
mv dotfiles/bin .
mv dotfiles/.profile .
mv dotfiles/.fehbg .
mv dotfiles/.config/* .config