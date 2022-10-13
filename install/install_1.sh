#!/bin/bash

read -p 'Enter Hostname: ' hostname
read -p 'Enter Username: ' username
read -p 'Enter EFI partition (full path): ' efi_partition
read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system

echo "-------------------------------------------"
echo "Installing base system..."

pacman -S --noconfirm --needed micro sudo grub efibootmgr dosfstools os-prober mtools > /dev/null

if [ $system = 'h' ]; then
    pacman -S --noconfirm --needed ntfs-3g
elif [ $system = 'v' ]; then
    echo "Installed VMware tools"
    pacman -S --noconfirm --needed open-vm-tools > /dev/null
elif [ $system = 'b' ]; then
    echo "Installed VirtualBox tools"
    pacman -S --noconfirm --needed vitualbox-guest-utils > /dev/null
fi

echo "-------------------------------------------"
echo "Setting clock and timezone"

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime > /dev/null
hwclock --systohc > /dev/null

echo "-------------------------------------------"
echo "Setting locale"

sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen > /dev/null
locale-gen > /dev/null

echo "-------------------------------------------"
echo "Setting constants"

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo $hostname >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   hostname.localdomain   hostname" >> /etc/hosts

echo "-------------------------------------------"
echo "Set ROOT password"

passwd

useradd -m $username > /dev/null

echo "-------------------------------------------"
echo "Set User Password"

passwd $username
usermod -aG wheel,audio,video,optical,storage $username > /dev/null

EDITOR=micro visudo

echo "-------------------------------------------"
echo "Setup GRUB"

mkdir /efi > /dev/null
mount $efi_partition /efi > /dev/null
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck > /dev/null
os-prober
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

echo "-------------------------------------------"
echo "Setup NetworkManager and System"

pacman -S --noconfirm --needed networkmanager > /dev/null

systemctl enable NetworkManager > /dev/null

if [ $system != 'h' ]; then
    echo "Install gtkmm3"
    pacman -S --noconfirm --needed gtkmm3 > /dev/null
fi

if [ $system = 'v' ]; then
    echo "Enabled VMware services"
    systemctl enable vmtoolsd.service > /dev/null
    systemctl enable vmware-vmblock-fuse.service > /dev/null
else [ $system = 'b' ]; then
    echo "Enabled VirtualBox services"
    systemctl enable vboxservice.service > /dev/null
fi

echo "-------------------------------------------"
echo "Change ownership of dotfiles"

chown -R $username /root/dotfiles
chgrp -R $username /root/dotfiles

echo "-------------------------------------------"
echo "NOW RUN THESE:"
echo ""
echo "mv dotfiles /home/$username"
echo "exit"
echo "umount -l /mnt"
echo "reboot" 
echo "-------------------------------------------"