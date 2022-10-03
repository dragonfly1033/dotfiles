#!/bin/bash

read -p 'Enter Hostname' hostname &
read -p 'Enter Username' username &

pacman -S micro sudo grub efibootmgr dosfstools os-prober mtools &

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime &
hwclock --systohc &

sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen &
locale-gen &

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf &
echo "KEYMAP=uk" >> /etc/vconsole.conf &
echo $hostname >> /etc/hostname &

echo "127.0.0.1   localhost" >> /etc/hosts &
echo "::1         localhost" >> /etc/hosts &
echo "127.0.1.1   hostname.localdomain   hostname" >> /etc/hosts &

passwd &

useradd -m $username &
passwd $username &
usermod -aG wheel,audio,video,optical,storage $username &

EDITOR=micro visudo &

mkdir /boot/EFI &
mount /dev/sda1 /boot/EFI &
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck &
grub-mkconfig -o /boot/grub/grub.cfg &

pacman -S networkmanager &

systemctl enable NetworkManager &

echo "NOW RUN THESE:"
echo "----------------"
echo "exit"
echo "umount -l /mnt"
echo "reboot"