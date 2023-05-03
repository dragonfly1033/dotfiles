#!/bin/bash

echo "-------------------------------------------"
echo "Install AUR Helper"

git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null

echo "-------------------------------------------"
echo "Install fonts"

yay -S --needed picom-jonaburg-git bt-dualboot nbfc-linux
cd ..

echo "-------------------------------------------"
echo "Move directories to correct places"

mkdir Downloads
mkdir Documents
mkdir Desktop
mkdir Pictures
ln -s .dotfiles/wallpapers Pictures/wallpapers
ln -s .dotfiles/.config/* .config
ln -s .dotfiles/home/* .

git clone "https://github.com/BlingCorp/bling.git" "~/.config/awesome/bling"
