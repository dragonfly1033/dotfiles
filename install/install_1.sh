#!/bin/bash

read -p 'Enter Hostname: ' hostname
read -p 'Enter Username: ' username
read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system

echo "--------------------------------------------------------------------------------------"
echo "Set ROOT password"
echo "--------------------------------------------------------------------------------------"

passwd

echo "--------------------------------------------------------------------------------------"
echo "Set User Password"
echo "--------------------------------------------------------------------------------------"

useradd -m $username > /dev/null
passwd $username
usermod -aG wheel,audio,video,optical,storage $username > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "CLOCK & TIMEZONE"
echo "--------------------------------------------------------------------------------------"

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime > /dev/null
hwclock --systohc > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "LOCALE"
echo "--------------------------------------------------------------------------------------"

sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen > /dev/null
locale-gen > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "HOSTS & CONSTS"
echo "--------------------------------------------------------------------------------------"

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo $hostname >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   hostname.localdomain   hostname" >> /etc/hosts

sed -ri 's/^#?ParallelDownloads.*/ParallelDownloads=5/' /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Syyu

echo "--------------------------------------------------------------------------------------"
echo "INSTALL ESSENTIALS"
echo "--------------------------------------------------------------------------------------"

pacman -S --noconfirm --needed micro sudo grub efibootmgr dosfstools os-prober mtools > /dev/null

if [ $system = 'h' ]; then
    echo "Install ntfs-3g"
    pacman -S --noconfirm --needed ntfs-3g > /dev/null
    echo "Install gtkmm3"
    pacman -S --noconfirm --needed gtkmm3 > /dev/null
    echo "Install hardware drivers"
    pacman -S --noconfirm --needed xf86-video-amdgpu > /dev/null
elif [ $system = 'v' ]; then
    echo "Installed VMware tools"
    pacman -S --noconfirm --needed open-vm-tools > /dev/null
    echo "Enabled VMware services"
    systemctl enable vmtoolsd.service > /dev/null
    systemctl enable vmware-vmblock-fuse.service > /dev/null
    echo "Install VMWare drivers"
    pacman -S --noconfirm --needed xf86-video-vmware xf86-input-vmmouse > /dev/null
elif [ $system = 'b' ]; then
    echo "Installed VirtualBox tools"
    pacman -S --noconfirm --needed virtualbox-guest-utils > /dev/null
    echo "Enabled VirtualBox services"
    systemctl enable vboxservice.service > /dev/null
fi


echo "--------------------------------------------------------------------------------------"
echo "SETUP SUDO"
echo "--------------------------------------------------------------------------------------"

# echo "-------------------------------------------"
# echo "Uncomment the line that says(in 10 secs):     %wheel ALL=(ALL) ALL"
# sleep 5
# echo "5"
# sleep 1
# echo "4"
# sleep 1
# echo "3"
# sleep 1
# echo "2"
# sleep 1
# echo "1"
# sleep 1

# EDITOR=micro visudo

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/custom
echo "%wheel ALL=(ALL:ALL) NOPASSWD: /sbin/shutdown" >> /etc/sudoers.d/custom
echo "%wheel ALL=(ALL:ALL) NOPASSWD:SETENV: /usr/bin/plymouth-set-default-theme" >> /etc/sudoers.d/custom

echo "--------------------------------------------------------------------------------------"
echo "GRUB"
echo "--------------------------------------------------------------------------------------"

sed -i '/#GRUB_DISABLE_OS_PROBER/c\GRUB_DISABLE_OS_PROBER=false' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub_uefi --recheck > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "NETWORKING"
echo "--------------------------------------------------------------------------------------"

pacman -S --noconfirm --needed networkmanager > /dev/null

systemctl enable NetworkManager > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "INSTALL PROGRAMS"
echo "--------------------------------------------------------------------------------------"

pacman -S --noconfirm --needed "$(cat /dotfiles/install/pac_pkgs)" > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "Remove legacy graphics driver"
echo "--------------------------------------------------------------------------------------"

pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "LOGIN & SPLASH"
echo "--------------------------------------------------------------------------------------"

pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan plymouth > /dev/null

cp /dotfiles/files/lightdm-plymouth.service /usr/lib/systemd/system
mkdir /usr/share/backgrounds
cp /dotfiles/files/black_background.png /usr/share/backgrounds
cp -r "/dotfiles/files/plymouth_themes/*" /usr/share/plymouth/themes

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
echo "GRUB_RECORDFAIL_TIMEOUT=\$GRUB_TIMEOUT" > /etc/default/grub

sed -ri 's/MODULES=\((.*)\)$/MODULES=\(\1 amdgpu\)/' /etc/mkinitcpio.conf
sed -ri 's/HOOKS=\(base udev (.*)\)/HOOKS=\(base udev plymouth \1\)/' /etc/mkinitcpio.conf   

grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P > /dev/null

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
cp /dotfiles/files/ly/config.ini /etc/ly/

echo "--------------------------------------------------------------------------------------"
echo "CRON"
echo "--------------------------------------------------------------------------------------"

sed -i "s/USER/$username/g" /dotfiles/files/cron/user
sed -i "s/USER/$username/g" /dotfiles/files/cron/root

crontab -u $username /dotfiles/files/cron/user
crontab -u root /dotfiles/files/cron/root

echo "--------------------------------------------------------------------------------------"
echo "MOVE FONTS"
echo "--------------------------------------------------------------------------------------"

mkdir -p .local/share/fonts/MyFonts
ln -s "/dotfiles/fonts/*" "/home/$username/.local/share/fonts/MyFonts"

echo "--------------------------------------------------------------------------------------"
echo "CHANGE PERMS"
echo "--------------------------------------------------------------------------------------"

chmod +x /dotfiles/home/bin
chmod +x "/dotfiles/home/*"
chmod -R +x /dotfiles/.config

echo "--------------------------------------------------------------------------------------"
echo "RELOCATE DOTS"
echo "--------------------------------------------------------------------------------------"

chown -R $username /dotfiles
chgrp -R $username /dotfiles

mv /dotfiles /home/$username/.dotfiles

echo "--------------------------------------------------------------------------------------"
echo "LINK DOTS"
echo "--------------------------------------------------------------------------------------"

mkdir /home/$username/Downloads
mkdir /home/$username/Documents
mkdir /home/$username/Desktop
mkdir /home/$username/Pictures
ln -s "/home/$username/.dotfiles/wallpapers" /home/$username/Pictures/wallpapers
ln -s "/home/$username/.dotfiles/.config/*" /home/$username/.config
ln -s "/home/$username/.dotfiles/home/*" /home/$username

git clone "https://github.com/BlingCorp/bling.git" "/home/$username/.config/awesome/bling"

echo "-------------------------------------------"
echo "NOW RUN THESE:"
echo ""
echo "exit"
echo "umount -l /mnt"
echo "reboot" 
echo "-------------------------------------------"