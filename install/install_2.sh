#!/bin/sh

script /dotfiles/log_2

sed -r '/install_2/ d' -i /home/$username/.bashrc

if [ "$(whoami)" != "root" ]; then
    echo "Remember to exit chroot, unmount and reboot"
    echo "Run this script as user not root"
    exit
fi

echo "--------------------------------------------------------------------------------------"
echo "INSTALL PROGRAMS"
echo "--------------------------------------------------------------------------------------"

if [ "$size" = "f" ]; then
    pacman -S --noconfirm --needed $(cat /dotfiles/install/pac_pkgs | xargs)
elif [ "$size" = "m" ]; then
    pacman -S --noconfirm --needed $(cat /dotfiles/install/pac_min_pkgs | xargs)
fi

echo "--------------------------------------------------------------------------------------"
echo "Remove legacy graphics driver"
echo "--------------------------------------------------------------------------------------"

pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "LOGIN & SPLASH"
echo "--------------------------------------------------------------------------------------"

pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan plymouth

cp /dotfiles/files/lightdm-plymouth.service /usr/lib/systemd/system
mkdir /usr/share/backgrounds
cp /dotfiles/files/black_background.png /usr/share/backgrounds
cp -r "/dotfiles/files/plymouth_themes"/* /usr/share/plymouth/themes

# sed -i '/#animate/c\animate=false' /etc/ly/config.ini
# sed -i '/#asterisk/c\asterisk=o' /etc/ly/config.ini
# sed -i '/#margin_box_w/c\margin_box_w=6' /etc/ly/config.ini
# sed -i '/#margin_box_h/c\margin_box_h=25' /etc/ly/config.ini
# sed -i '/#blank_password/c\blank_password=true' /etc/ly/config.ini

sed -ri 's/^#?greeter-session=.*/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
sed -ri 's/^#?webkit_theme.*/webkit_theme=litarvan/' /etc/lightdm/lightdm-webkit2-greeter.conf
sed -ri 's/^#?debug_mode.*/debug_mode=true/' /etc/lightdm/lightdm-webkit2-greeter.conf

sed -ri 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 splash udev.log_level=3 rd.udev.log_level=3 loglevel=3 vt.global_cursor_default=0"/' /etc/default/grub
sed -ri 's/^#?GRUB_DEFUALT=.*/GRUB_DEFAULT=0/' /etc/default/grub
sed -ri 's/^#?GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
echo "GRUB_RECORDFAIL_TIMEOUT=\$GRUB_TIMEOUT" | tee -a /etc/default/grub
 
sed -ri 's/MODULES=\((.*)\)$/MODULES=\(\1 amdgpu\)/' /etc/mkinitcpio.conf
sed -ri 's/HOOKS=\(base udev (.*)\)/HOOKS=\(base udev plymouth \1\)/' /etc/mkinitcpio.conf   

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable lightdm-plymouth.service

plymouth-set-default-theme -R rings > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "XORG CONFS"
echo "--------------------------------------------------------------------------------------"

cp /dotfiles/files/50-touchpad.conf /etc/X11/xorg.conf.d
chmod +xr /etc/X11/xorg.conf.d/50-touchpad.conf
cp /dotfiles/files/40-libinput.conf /usr/share/X11/xorg.conf.d
chmod +xr /usr/share/X11/xorg.conf.d/40-libinput.conf
cp /dotfiles/files/10-amdgpu.conf /usr/share/X11/xorg.conf.d
chmod +xr /usr/share/X11/xorg.conf.d/10-amdgpu.conf

echo "--------------------------------------------------------------------------------------"
echo "MOVE SYSTEM FILES"
echo "--------------------------------------------------------------------------------------"

cp /dotfiles/files/pfetch /usr/bin
# cp /dotfiles/files/ly/config.ini /etc/ly

echo "--------------------------------------------------------------------------------------"
echo "CRON"
echo "--------------------------------------------------------------------------------------"

sed -i "s/USER/$username/g" /dotfiles/files/cron/user
sed -i "s/USER/$username/g" /dotfiles/files/cron/root

crontab -u "$username" /dotfiles/files/cron/user
crontab -u root /dotfiles/files/cron/root

echo "--------------------------------------------------------------------------------------"
echo "CHANGE PERMS"
echo "--------------------------------------------------------------------------------------"

chmod +x /dotfiles/home/bin
chmod +x "/dotfiles/home"/*
chmod -R +x /dotfiles/.config

echo "--------------------------------------------------------------------------------------"
echo "RELOCATE DOTS"
echo "--------------------------------------------------------------------------------------"

chown -R $username /dotfiles
chgrp -R $username /dotfiles

mv /dotfiles /home/$username/.dotfiles
