#!/bin/bash



echo "-------------------------------------------"
echo "Install Yay Packages"

yes | LANG=C yay -S --batchinstall --norebuild --answerclean All --answerdiff None --mflags "--noconfirm" $(cat .dotfiles/install/yay_pkgs | xargs)

echo "-------------------------------------------"
echo "Move directories to correct places"

mkdir Downloads
mkdir Documents
mkdir Desktop
mkdir Pictures
ln -s ~/.dotfiles/wallpapers ~/Pictures/wallpapers
ln -s ~/.dotfiles/.config/* ~/.config
ln -s ~/.dotfiles/home/* ~/.

git clone "https://github.com/BlingCorp/bling.git" "~/.config/awesome/bling"
