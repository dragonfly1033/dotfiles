#!/bin/bash


git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
yay -S --needed --noconfirm picom-jonaburg-git ttf-raleway
cd ..

mkdir Pictures 
mv dotfiles/wallpapers Pictures
mv dotfiles/scripts .
mv dotfiles/.themes .
mv dotfiles/bin .
mv dotfiles/.profile .
mv dotfiles/.fehbg .
mv dotfiles/.config/* .config
sudo mkdir -p /usr/local/share/fonts
sudo mv dotfiles/fonts/MyFonts /usr/local/share/fonts