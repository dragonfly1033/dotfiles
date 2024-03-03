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

echo "--------------------------------------------------------------------------------------"
echo "INSTALL ESSENTIALS"
echo "--------------------------------------------------------------------------------------"

pacman -Syyu > /dev/null
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

echo "-------------------------------------------"
echo "NOW RUN THESE:"
echo ""
echo "exit"
echo "umount -l /mnt"
echo "reboot" 
echo "-------------------------------------------"

