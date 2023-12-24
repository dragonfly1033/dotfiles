#!/bin/bash

read -p 'Enter Username: ' username
read -p 'Enter EFI partition (full path): ' efi_partition
read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system

echo "-------------------------------------------"
echo "Install AUR Helper"

git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null


echo "-------------------------------------------"
echo "Install Drivers"

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
echo "Install Pacman Packages"

pacman -S --noconfirm --needed - < .dotfiles/install/pac_pkgs

echo "-------------------------------------------"
echo "Uninstall vesa"

pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "-------------------------------------------"
echo "Install login and Boot splash"

pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan plymouth

cp ~/.dotfiles/files/lightdm-plymouth.service /usr/lib/systemd/system
mkdir /usr/share/backgrounds
cp ~/.dotfiles/files/black_background.png /usr/share/backgrounds
cp -r ~/.dotfiles/files/plymouth_themes/* /usr/share/plymouth/themes

echo "-------------------------------------------"
echo "Configure Login and Boot splash"

# sed -i '/#animate/c\animate=false' /etc/ly/config.ini
# sed -i '/#asterisk/c\asterisk=o' /etc/ly/config.ini
# sed -i '/#margin_box_w/c\margin_box_w=6' /etc/ly/config.ini
# sed -i '/#margin_box_h/c\margin_box_h=25' /etc/ly/config.ini
# sed -i '/#blank_password/c\blank_password=true' /etc/ly/config.ini

sed -ri 's/^#?greeter-session=.*/greeter-session=qwe/' /etc/lightdm/lightdm.conf
sed -ri 's/^#?webkit_theme.*/webkit_theme=qwe/' /etc/lightdm/lightdm-webkit2-greeter.conf
sed -ri 's/^#?debug_mode.*/debug_mode=qwe/' /etc/lightdm/lightdm-webkit2-greeter.conf

sed -ri 's/GRUB_CMDLINE_LINUX_DEFAULT="(.*)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 splash"/' /etc/default/grub

sed -ri 's/MODULES=\((.*)\)$/MODULES=\(\1 amdgpu\)/' /etc/mkinitcpio.conf
sed -ri 's/HOOKS=\(base udev (.*)\)/HOOKS=\(base udev plymouth \1\)/' /etc/mkinitcpio.conf   

grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

systemctl enable lightdm-plymouth.service

plymouth-set-default-theme -R rings


echo "-------------------------------------------"
echo "Configure xinitrc"

touch .xinitrc
head -n -5 /etc/X11/xinit/xinitrc >> .xinitrc
echo "exec awesome" >> .xinitrc
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
echo "Moving files"

cp .dotfiles/files/pfetch /usr/bin
cp .dotfiles/files/ly/config.ini /etc/ly/


echo "-------------------------------------------"
echo "Configure cron"

sed -i "s/USER/$username/g" .dotfiles/files/cron/user
sed -i "s/USER/$username/g" .dotfiles/files/cron/root

crontab -u $username .dotfiles/files/cron/user
crontab -u root .dotfiles/files/cron/root

echo "-------------------------------------------"
echo "Move fonts"

mkdir -p .local/share/fonts/MyFonts
ln -s ~/.dotfiles/fonts/* ~/.local/share/fonts/MyFonts

echo "-------------------------------------------"
echo "Change Perms"

chmod -R +x .dotfiles/home
chmod -R +x .dotfiles/.config

echo "--------------------------------------------------------------------------------------"
echo "Run install_3"
echo "--------------------------------------------------------------------------------------"

~/.dotfiles/install/install_3.sh
