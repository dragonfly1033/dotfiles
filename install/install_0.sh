#!/bin/sh

echo "--------------------------------------------------------------------------------------"
echo "STARTING PARTITIONING"
echo "--------------------------------------------------------------------------------------"

read -p "Enter Disk Device(full path): " disk

ram_size=$(free -h --si | grep Mem | tr -s ' ' | cut -d' ' -f2)

if [ -z $ram_size ]; then
	read -p 'Enter total RAM space number only (GB): ' ram_size
fi
	
fdisk $disk << EOF
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

read -p "Enter Boot Partition(full path): " boot_part
read -p "Enter SWAP Partition(full path): " swap_part
read -p "Enter Root Partition(full path): " root_part

mkfs.fat -F32 $boot_part
mkswap $swap_part
mkfs.ext4 $root_part

mount --mkdir $root_part /mnt
mount --mkdir $boot_part /mnt/boot
swapon $swap_part

echo "--------------------------------------------------------------------------------------"
echo "BASIC INSTALLS"
echo "--------------------------------------------------------------------------------------"

pacstrap /mnt base linux linux-firmware base-devel

echo "--------------------------------------------------------------------------------------"
echo "GENERATE FS TABLE"
echo "--------------------------------------------------------------------------------------"

genfstab -U /mnt >> /mnt/etc/fstab

echo "--------------------------------------------------------------------------------------"
echo "CHROOT"
echo "--------------------------------------------------------------------------------------"

arch-chroot /mnt

echo "--------------------------------------------------------------------------------------"
echo "Run install_1"
echo "--------------------------------------------------------------------------------------"


