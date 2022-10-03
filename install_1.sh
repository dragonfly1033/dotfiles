#!/bin/bash

read -p 'Enter Hostname: ' hostname
read -p 'Enter Username: ' username

echo "Installing base system..."
pacman -S --noconfirm micro sudo grub efibootmgr dosfstools os-prober mtools

echo "Setting clock and timezone"
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

echo "Setting locale"
sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen
locale-gen

echo "Setting constants"
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo $hostname >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   hostname.localdomain   hostname" >> /etc/hosts

echo ""
echo ""
echo "Set ROOT password"
passwd

useradd -m $username
echo ""
echo ""
echo "Set User Password"
passwd $username
usermod -aG wheel,audio,video,optical,storage $username

EDITOR=micro visudo

echo "Setup grub"
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo "Setup Network Manager"
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

sed -i 's/\r$//' /root/dotfiles/install_2_sudo.sh
sed -i 's/\r$//' /root/dotfiles/install_3.sh

echo "NOW RUN THESE:"
echo "----------------"
echo "mv dotfiles /home/$username"
echo "exit"
echo "umount -l /mnt"
echo "reboot" 
echo "----------------"