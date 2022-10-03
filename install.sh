#!/bin/sh

pacman -S ttf-iosevka-nerd &
mv bin .. &
mv .config .. &
mv fonts/* /usr/local/share/fonts/ &
mv scripts .. &
mv .themes .. &
mkdir ~/Pictures ; mv wallpapers ../Pictures &
