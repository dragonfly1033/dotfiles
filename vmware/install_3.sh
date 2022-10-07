#!/bin/bash

echo "-------------------------------------------"
echo "Install AUR Helper"

git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null

echo "-------------------------------------------"
echo "Install fonts"

yay -S --needed picom-jonaburg-git ttf-raleway > /dev/null
cd ..

echo "-------------------------------------------"
echo "Move directories to correct places"

mkdir Pictures
mv dotfiles/wallpapers Pictures
mv dotfiles/scripts .
mv dotfiles/.themes .
mv dotfiles/bin .
mv dotfiles/.profile .
mv dotfiles/.fehbg .
mv dotfiles/.config/* .config