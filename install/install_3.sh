#!/bin/sh

sed -r '/install_3/ d' -i /home/$username/.bashrc

# read -p 'Enter System Size (f)ull, (m)inimal: ' size
# while [ "$size" != "f" ] && [ "$size" != "m" ]; do
#     echo "Please enter a valid input."
#     read -p 'Enter System Size (f)ull, (m)inimal: ' size
# done

echo "--------------------------------------------------------------------------------------"
echo "LINK DOTS"
echo "--------------------------------------------------------------------------------------"

mkdir /home/$username/Downloads
mkdir /home/$username/Documents
mkdir /home/$username/Desktop
mkdir /home/$username/Pictures

for i in $(ls -A /home/$username/.dotfiles/.config); do
    ln -s "/home/$username/.dotfiles/.config/$i" "/home/$username/.config"
done

for i in $(ls -A /home/$username/.dotfiles/home); do
    ln -s "/home/$username/.dotfiles/home/$i" "/home/$username"
done

mkdir -p ~/.local/share/fonts/MyFonts

for i in $(ls -A /home/$username/.dotfiles/fonts); do
    ln -s "/home/$username/.dotfiles/fonts/$i" "/home/$username/.local/share/fonts/MyFonts"
done

ln -s "/home/$username/.dotfiles/wallpapers" /home/$username/Pictures/wallpapers

reboot
