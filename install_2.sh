#!/bin/bash

curl https://aur.archlinux.org/yay.git
cd yay
makepkg -si

pacman -S picom xorg xorg-xinit xterm awesome pacman-contrib
pacman -S mlocate feh alacritty firefox rofi polybar cronie dunst exa tree openssh gpick
pacman -S lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan

sed -i '/#greeter-session/c\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
sed -i '/#width/c\width=1920' /etc/lightdm/lightdm.conf
sed -i '/#height/c\height=1080' /etc/lightdm/lightdm.conf
sed -i '/webkit-theme/c\webkit_theme=litarvan' /etc/lightdm/lightdm-webkit2-greeter.conf

yay -S picom-jonaburg-git 
