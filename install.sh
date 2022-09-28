#!/bin/sh


micro
sudo
grub
efibootmgr
dosfstools
os-prober
mtools
networkmanager
git
yay
picom
picom-jonaburg-git
xorg
xorg-xinit
mlocate
feh
alacritty
xterm
awesome
firefox
lightdm
lightdm-webkit2-greeter
lightdm-webkit-theme-litarvan
rofi
polybar
dunst
cronie
exa
tree
openssh
pacman-contrib
gpick




pacman -S ttf-iosevka-nerd ttf-raleway-variable &
mv bin .. &
cp .config/* ../.config &
mv -r fonts/* /usr/local/share/fonts/ &
mv scripts .. &
mv .themes .. &
mkdir ~/Pictures &
mv -r wallpapers ../Pictures &
