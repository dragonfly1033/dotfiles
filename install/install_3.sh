#!/bin/sh

echo "--------------------------------------------------------------------------------------"
echo "INSTALL YAY"
echo "--------------------------------------------------------------------------------------"

git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null
cd

echo "--------------------------------------------------------------------------------------"
echo "INSTALL AUR PKGS"
echo "--------------------------------------------------------------------------------------"

yes '
' | yay -S --needed --mflags "--noconfirm" "$(cat ~/.dotfiles/install/yay_pkgs | xargs)"


