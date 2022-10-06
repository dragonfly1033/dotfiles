#!/bin/bash

read -p 'Enter Hostname: ' hostname
read -p 'Enter Username: ' username

echo "Installing base system..."

pacman -S --noconfirm --needed micro sudo grub efibootmgr dosfstools os-prober mtools > /dev/null

echo "Setting clock and timezone"

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime > /dev/null
hwclock --systohc > /dev/null

echo "Setting locale"

sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen > /dev/null
locale-gen > /dev/null

echo "Setting constants"

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo $hostname >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   hostname.localdomain   hostname" >> /etc/hosts

echo ""
echo "Set ROOT password"

passwd

useradd -m $username > /dev/null

echo ""
echo "Set User Password"

passwd $username
usermod -aG wheel,audio,video,optical,storage $username > /dev/null

EDITOR=micro visudo

echo "Setup GRUB"

mkdir /boot/EFI > /dev/null
mount /dev/sda1 /boot/EFI > /dev/null
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

echo "Setup Network Manager and VMware"

pacman -S --noconfirm --needed networkmanager gtkmm3 > /dev/null

systemctl enable NetworkManager > /dev/null
systemctl enable vmtoolsd.service > /dev/null
systemctl enable vmware-vmblock-fuse.service > /dev/null

echo "Correct CRLF in other install scripts"

sed -i 's/\r$//' /root/dotfiles/install_2_sudo.sh
sed -i 's/\r$//' /root/dotfiles/install_3.sh

echo "Change ownership of dotfiles"

chown -R $username /root/dotfiles
chgrp -R $username /root/dotfiles

echo ""
echo "NOW RUN THESE:"
echo "----------------"
echo "mv dotfiles /home/$username"
echo "exit"
echo "umount -l /mnt"
echo "reboot" 
echo "----------------"