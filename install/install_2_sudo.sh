#!/bin/bash

read -p 'Enter Username: ' username
read -p 'Enter EFI partition (full path): ' efi_partition
read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system

echo "-------------------------------------------"
echo "Add Windows to boot menu"

sed -i '/#GRUB_DISABLE_OS_PROBER/c\GRUB_DISABLE_OS_PROBER=false' /etc/default/grub
mount $efi_partition /boot
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

pacman -S --noconfirm --needed mlocate htop acpi feh neofetch alacritty firefox rofi polybar cronie exa tree openssh gpick > /dev/null
pacman -S --noconfirm --needed bluez bluez-utils blues-libs pulseaudio pulseaudio-bluetooth pulseaudio-alsa pavucontrol zsh blueman brightnessctl ntfs-3g pandoc xbindkeys xdotool xclip > /dev/null
pacman -S --noconfirm --needed libreoffice-still pcmanfm flameshot zsh-theme-powerlevel10k-git lm_sensors mtpfs android-udev syncthing vlc tlp cpupower > /dev/null

echo "-------------------------------------------"
echo "Install login"

pacman -S --noconfirm --needed --overwrite ly > /dev/null

echo "-------------------------------------------"
echo "Install fonts"

pacman -S --noconfirm --needed ttf-iosevka-nerd noto-fonts-cjk noto-fonts-emoji noto-fonts nerd-fonts-complete > /dev/null

echo "-------------------------------------------"
echo "Uninstall vesa"
pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "-------------------------------------------"
echo "Enable login"

systemctl enable ly

echo "-------------------------------------------"
echo "Configure Login"

sed -i '/#animate/c\animate=false' /etc/ly/config.ini
sed -i '/#asterisk/c\asterisk=o' /etc/ly/config.ini
sed -i '/#margin_box_w/c\margin_box_w=6' /etc/ly/config.ini
sed -i '/#margin_box_h/c\margin_box_h=25' /etc/ly/config.ini
sed -i '/#blank_password/c\blank_password=true' /etc/ly/config.ini

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

cp .dotfiles/files/50-touchpad.conf /etc/X11/xorg.conf.d
chmod +xr /etc/X11/xorg.conf.d/50-touchpad.conf
cp .dotfiles/files/40-libinput.conf /usr/share/X11/xorg.conf.d
chmod +xr /usr/share/X11/xorg.conf.d/40-libinput.conf
cp .dotfiles/files/10-amdgpu.conf /usr/share/X11/xorg.conf.d
chmod +xr /usr/share/X11/xorg.conf.d/10-amdgpu.conf

echo "-------------------------------------------"
echo "Configure cron"

sed -i "s/USER/$username/g" .dotfiles/files/cron/user
sed -i "s/USER/$username/g" .dotfiles/files/cron/root

echo "* * */1 * * /home/$username/bin/backup_cron" >> .dotfiles/files/cron/root

crontab -u $username .dotfiles/files/cron/user
crontab -u root .dotfiles/files/cron/root


echo "-------------------------------------------"
echo "Move fonts"

mkdir -p /usr/local/share/fonts
ln -s .dotfiles/fonts/* /usr/local/share/fonts

echo "-------------------------------------------"
echo "Change Perms"

chmod -R +x .dotfiles/home
chmod -R +x .dotfiles/.config

