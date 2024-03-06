#!/bin/sh

echo "--------------------------------------------------------------------------------------"
lsblk
echo "--------------------------------------------------------------------------------------"

read -p "Enter Disk Device(full path): " disk

ram_size=$(free -h --si | grep Mem | tr -s ' ' | cut -d' ' -f2)

if [ -z $ram_size ]; then
	read -p 'Enter total RAM space number only (GB): ' ram_size
fi

read -p 'Enter Hostname: ' hostname
while [ -z "$hostname" ]; do
	echo "Please enter a valid input."
	read -p 'Enter Hostname: ' hostname
done

read -p 'Enter Username: ' username
while [ -z "$username" ]; do
	echo "Please enter a valid input."
	read -p 'Enter Username: ' username
done

read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system
while [ "$system" != "h" ] &&  [ "$system" != "v" ] &&  [ "$system" != "b" ]; do
	echo "Please enter a valid input."
	read -p 'Enter System (h)ardware, (v)mware, virtual(b)ox: ' system
done

read -p 'Enter System Size (f)ull, (m)inimal: ' size
while [ "$size" != "f" ] && [ "$size" != "m" ]; do
	echo "Please enter a valid input."
	read -p 'Enter System Size (f)ull, (m)inimal: ' size
done

echo "--------------------------------------------------------------------------------------"
echo "STARTING PARTITIONING"
echo "--------------------------------------------------------------------------------------"
	
fdisk $disk > /dev/null << EOF
g
n


+512M
n


+$ram_size
n



t
1
1
t
2
19
w
EOF

echo "--------------------------------------------------------------------------------------"
echo "CHECKING PARTITIONING"
echo "--------------------------------------------------------------------------------------"

lsblk

echo "--------------------------------------------------------------------------------------"
echo "FORMATTING"
echo "--------------------------------------------------------------------------------------"

# read -p "Enter Boot Partition(full path): " boot_part
# read -p "Enter SWAP Partition(full path): " swap_part
# read -p "Enter Root Partition(full path): " root_part

boot_part="$disk"1
swap_part="$disk"2
root_part="$disk"3

mkfs.fat -F32 $boot_part > /dev/null
mkswap $swap_part > /dev/null
mkfs.ext4 $root_part > /dev/null

mount --mkdir $root_part /mnt
mount --mkdir $boot_part /mnt/boot
swapon $swap_part

echo "--------------------------------------------------------------------------------------"
echo "BASIC INSTALLS"
echo "--------------------------------------------------------------------------------------"

sed -ri 's/^#?ParallelDownloads.*/ParallelDownloads=5/' /etc/pacman.conf

pacman -Syy --noconfirm --needed > /dev/null

pacstrap -K /mnt base linux linux-firmware base-devel git

echo "--------------------------------------------------------------------------------------"
echo "GENERATE FS TABLE"
echo "--------------------------------------------------------------------------------------"

genfstab -U /mnt >> /mnt/etc/fstab

echo "--------------------------------------------------------------------------------------"
echo "GET DOTS"
echo "--------------------------------------------------------------------------------------"

pacman -Sy --needed --noconfirm > /dev/null
pacman -S --needed --noconfirm git > /dev/null

git clone https://github.com/dragonfly1033/dotfiles.git /mnt/dotfiles > /dev/null
chmod +x "/mnt/dotfiles/install/install_*"

echo "--------------------------------------------------------------------------------------"
echo "After chroot run /dotfiles/install/install_1.sh"
echo "--------------------------------------------------------------------------------------"

clear

echo "--------------------------------------------------------------------------------------"
echo "CHROOT"
echo "--------------------------------------------------------------------------------------"

arch-chroot /mnt /bin/bash -c script -qc "username=\"$username\" hostname=\"$hostname\" system=\"$system\" size=\"$size\" /dotfiles/install/install_1.sh" /mnt/dotfiles/log_1

read -p "Install_1 fininshed. Continue?" alsdnskln

umount -l /mnt
reboot



