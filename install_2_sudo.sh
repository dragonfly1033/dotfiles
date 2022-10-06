#!/bin/bash

pacman -S --noconfirm --needed picom xorg xorg-xinit xterm awesome pacman-contrib xf86-input-vmmouse xf86-video-vmware mesa > /dev/null
pacman -S --noconfirm --needed mlocate feh alacritty firefox rofi polybar cronie dunst exa tree openssh gpick > /dev/null
pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan > /dev/null
pacman -S --noconfirm --needed ttf-iosevka-nerd neofetch > /dev/null

systemctl enable lightdm > /dev/null

sed -i '/#greeter-session/c\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
sed -i '/#width/c\width=1920' /etc/lightdm/lightdm.conf
sed -i '/#height/c\height=1080' /etc/lightdm/lightdm.conf
sed -i '/webkit_theme/c\webkit_theme=litarvan' /etc/lightdm/lightdm-webkit2-greeter.conf

touch .xinitrc
head -n -5 /etc/X11/xinit/xinitrc >> .xinitrc
echo "awesome &" >> .xinitrc

mkdir -p /usr/local/share/fonts
mv dotfiles/fonts/MyFonts /usr/local/share/fonts