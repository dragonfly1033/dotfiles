#!/bin/bash

read -p 'Enter Username: ' username
read -p 'Enter EFI partition (full path): ' efi_partition
read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system

echo "-------------------------------------------"
echo "Add Windows to boot menu"

sed -i '/#GRUB_DISABLE_OS_PROBER/c\GRUB_DISABLE_OS_PROBER=false' /etc/default/grub
mount $efi_partition /efi
os-prober > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

echo "-------------------------------------------"
echo "Install graphical system packages"

pacman -S --noconfirm --needed xorg xorg-xinit xterm awesome pacman-contrib libinput mesa > /dev/null

echo "-------------------------------------------"
if [ $system = 'h' ]; then
    echo "Install hardware drivers"
    pacman -S --noconfirm --needed xf86-video-amdgpu > /dev/null
elif [ $system = 'v' ]; then
    echo "Install VMWare drivers"
    pacman -S --noconfirm --needed xf86-video-vmware xf86-input-vmmouse > /dev/null
elif [ $system = 'b' ]; then
    echo "Install VirtualBox drivers"
    pacman -S --noconfirm --needed xf86-video-vmware > /dev/null
fi

echo "-------------------------------------------"
echo "Install apps and utils"

pacman -S --noconfirm --needed mlocate htop acpi feh neofetch alacritty firefox rofi polybar cronie dunst exa tree openssh gpick > /dev/null

echo "-------------------------------------------"
echo "Install login"

pacman -S --noconfirm --needed --overwrite \* lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan > /dev/null

echo "-------------------------------------------"
echo "Install fonts"

pacman -S --noconfirm --needed ttf-iosevka-nerd  > /dev/null

echo "-------------------------------------------"
echo "Uninstall vesa"
pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "-------------------------------------------"
echo "Enable login"

pacman -S --noconfirm --needed gdk-pixbuf2 > /dev/null
systemctl enable lightdm > /dev/null

echo "-------------------------------------------"
echo "Configure Login"

sed -i '/#greeter-session/c\greeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
sed -i '/#width/c\width=1920' /etc/lightdm/lightdm.conf
sed -i '/#height/c\height=1080' /etc/lightdm/lightdm.conf
sed -i '/^webkit_theme/c\webkit_theme=litarvan' /etc/lightdm/lightdm-webkit2-greeter.conf

echo "-------------------------------------------"
echo "Configure xinitrc"

touch .xinitrc
head -n -5 /etc/X11/xinit/xinitrc >> .xinitrc
echo "awesome" >> .xinitrc
chmod +x .xinitrc
chown $username .xinitrc
chgrp $username .xinitrc

echo "-------------------------------------------"
echo "Configure touchpad"

cp dotfiles/install/50-touchpad.conf /etc/X11/xorg.conf.d
chmod +xr /etc/X11/xorg.conf.d/50-touchpad.conf

echo "-------------------------------------------"
echo "Move fonts"

mkdir -p /usr/local/share/fonts
mv dotfiles/fonts/MyFonts /usr/local/share/fonts

echo "-------------------------------------------"
echo "Change Perms"

chmod -R +x dotfiles/scripts
chmod -R +x dotfiles/bin
chmod -R +x dotfiles/.config
chmod +x dotfiles/.bashrc
chmod +x dotfiles/.fehbg
