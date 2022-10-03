#!/bin/bash

pacman -S --noconfirm picom xorg xorg-xinit xterm awesome pacman-contrib
pacman -S --noconfirm mlocate feh alacritty firefox rofi polybar cronie dunst exa tree openssh gpick
pacman -S --noconfirm lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
pacman -S --noconfirm ttf-iosevka-nerd neofetch

sed -i '/#greeter-session/c\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
sed -i '/#width/c\width=1920' /etc/lightdm/lightdm.conf
sed -i '/#height/c\height=1080' /etc/lightdm/lightdm.conf
sed -i '/webkit_theme/c\webkit_theme=litarvan' /etc/lightdm/lightdm-webkit2-greeter.conf

