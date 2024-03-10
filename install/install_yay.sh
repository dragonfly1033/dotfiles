#!/bin/sh

username=$(whoami)

echo "--------------------------------------------------------------------------------------"
echo "INSTALL YAY"
echo "--------------------------------------------------------------------------------------"

git clone https://aur.archlinux.org/yay-bin.git /home/$username/yay-bin > /dev/null
cd /home/$username/yay-bin
makepkg -si > /dev/null
cd /home/$username
rm -rf yay-bin

echo ""
