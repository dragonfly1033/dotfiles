#!/bin/bash

setxkbmap gb &
sleep 3 &
xrandr -s 1920x1080 &
picom --no-vsync --experimental-backend &
~/.fehbg &
~/.config/polybar/launch.sh &
dunst &
