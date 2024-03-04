#!/bin/sh

echo "--------------------------------------------------------------------------------------"
echo "INSTALL AUR PKGS"
echo "--------------------------------------------------------------------------------------"

yes '
' | yay -S --sudoloop --needed --mflags "--noconfirm" $(cat ~/.dotfiles/install/yay_pkgs | xargs)


