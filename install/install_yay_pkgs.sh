#!/bin/sh

echo "--------------------------------------------------------------------------------------"
echo "INSTALL YAY"
echo "--------------------------------------------------------------------------------------"

git clone https://aur.archlinux.org/yay-bin.git /home/$username/yay-bin > /dev/null
cd /home/$username/yay-bin
yes '
' | makepkg -si > /dev/null
cd /home/$username
rm -rf yay-bin

echo ""

echo "--------------------------------------------------------------------------------------"
echo "INSTALL AUR PKGS"
echo "--------------------------------------------------------------------------------------"

if [ "$size" = "f" ]; then
    yes '
    ' | yay -S --sudoloop --needed --mflags "--noconfirm" $(cat ~/.dotfiles/install/yay_pkgs | xargs)
elif [ "$size" = "m" ]; then
    yes '
    ' | yay -S --sudoloop --needed --mflags "--noconfirm" $(cat ~/.dotfiles/install/yay_min_pkgs | xargs)
fi