#!/bin/bash

echo -n "Enter Name: "
read name
echo -n "Enter Accent: "
read accent
echo -n "Enter Accent 2: "
read accent2
echo -n "Enter Background: "
read bg
echo -n "Enter Text: "
read fg
echo -n "Enter Text Dark: "
read fgd
echo -n "Enter Wallpaper Name: "
read wpname

mkdir $HOME/.themes/$name
touch $HOME/.themes/$name/colours
touch $HOME/.themes/$name/wall
echo "$accent $accent2 $bg $fg $fgd" > $HOME/.themes/$name/colours
echo "$wpname" > $HOME/.themes/$name/wall
