#!/bin/bash

setxkbmap gb &
sleep 3 &
xrandr -s 1920x1080 &
picom --no-vsync --experimental-backend &
/home/arch/.fehbg &
. /home/arch/.config/polybar/launch.sh &
dunst &
