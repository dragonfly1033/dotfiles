 #!/bin/bash

theme=$1
path="${HOME}/.themes/${theme}"
sed_var=${HOME}/scripts/sed_var

newaccent=$(awk '{print $1}' "${path}/colours")
$sed_var "export ACCENT=" "\"#$newaccent\"" $HOME/.profile
$sed_var "theme.border_focus = " "\"#$newaccent\"" $HOME/.config/awesome/theme.lua
$sed_var "primary = " "#$newaccent" $HOME/.config/polybar/config.ini
$sed_var "accent: " "#$newaccent;" $HOME/.config/rofi/theme.rasi

newaccent2=$(awk '{print $2}' "${path}/colours")
$sed_var "export ACCENT2=" "\"#$newaccent2\"" $HOME/.profile
$sed_var "background-alt = " "#$newaccent2" $HOME/.config/polybar/config.ini

newback=$(awk '{print $3}' "${path}/colours")
$sed_var "export BACK=" "\"#$newback\"" $HOME/.profile
$sed_var "theme.border_normal = " "\"#$newback\"" $HOME/.config/awesome/theme.lua
$sed_var "theme.hotkeys_bg = " "\"#$newback\"" $HOME/.config/awesome/theme.lua
$sed_var "background = " "#$newback" $HOME/.config/polybar/config.ini
$sed_var "background-color: " "#$newback;" $HOME/.config/rofi/theme.rasi

newtext=$(awk '{print $4}' "${path}/colours")
$sed_var "export TEXT=" "\"#$newtext\"" $HOME/.profile
$sed_var "theme.hotkeys_modifiers_fg = " "\"#$newtext\"" $HOME/.config/awesome/theme.lua
$sed_var "theme.hotkeys_fg = " "\"#$newtext\"" $HOME/.config/awesome/theme.lua
$sed_var "foreground = " "#$newtext" $HOME/.config/polybar/config.ini
$sed_var "text-color: " "#$newtext;" $HOME/.config/rofi/theme.rasi

newtextd=$(awk '{print $5}' "${path}/colours")
$sed_var "export TEXTD=" "\"#$newtextd\"" $HOME/.profile
$sed_var "disabled = " "#$newtextd" $HOME/.config/polybar/config.ini

$sed_var "secondary = " "#$newaccent2" $HOME/.config/polybar/config.ini

wpname=$(cat $path/wall)
sed -i "2s@.*@feh --no-fehbg --bg-scale $HOME/Pictures/wallpapers/${wpname}@" $HOME/.fehbg

echo "awesome.restart()" | awesome-client
