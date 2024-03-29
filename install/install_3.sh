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
mkdir /home/$username/.config

for i in $(ls -A /home/$username/.dotfiles/.config); do
    ln -s "/home/$username/.dotfiles/.config/$i" "/home/$username/.config"
done

for i in $(ls -A /home/$username/.dotfiles/home); do
    ln -s "/home/$username/.dotfiles/home/$i" "/home/$username"
done

mkdir -p /home/$username/.local/share/fonts

for i in $(ls -A /home/$username/.dotfiles/fonts); do
    ln -s "/home/$username/.dotfiles/fonts/$i" "/home/$username/.local/share/fonts"
done

ln -s "/home/$username/.dotfiles/wallpapers" /home/$username/Pictures/wallpapers

sed "s!name=.*!name=\"$(/home/$username/bin/vars get THEME)\"!" -i /home/$username/.fehbg

echo "--------------------------------------------------------------------------------------"
echo "Setup install_post hook"
echo "--------------------------------------------------------------------------------------"

echo "/home/$username/.dotfiles/install/install_post.sh" >> /home/$username/.bashrc

reboot
