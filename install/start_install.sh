#!/bin/sh

set -e

input_notnull () {
    ret=""

    while [ -z "$ret" ]; do
        printf "%s" "$1" >&2
        read -r ret
    done
    
    echo "$ret"
}

input_confirm () {
    printf "%s" "$1" >&2
    read -r ret

    if [ "$ret" = "y" ]; then
        echo y
    else
        echo n
    fi
}

part () {
    if echo "$1" | grep nvme; then
        echo "$1p$2"
    else
        echo "$1$2"
    fi
}

echo "---------------------------"
echo "INSTALL PACKAGES FOR SCRIPT"
echo "---------------------------"

pacman -Syy
pacman -S --noconfirm --needed fzf git

clear

echo "------------------------"
echo "INPUT DATA"
echo "------------------------"

lsblk
echo "------------------------"

disk=$(input_notnull "Enter Disk Device (full path): ") || exit 1

[ -e "$disk" ] || exit 1

swap=$(input_confirm "Swap partition?(y/N): ") || exit 1
filesystem=$(printf "ext4\nbtrfs" | /usr/bin/fzf --prompt "File System: ") || exit 1
root_passwd=$(input_notnull "Enter Root Password: ") || exit 1
username=$(input_notnull "Enter Username: ") || exit 1
user_passwd=$(input_notnull "Enter User Password: ") || exit 1
hostname=$(input_notnull "Enter Hostname: ") || exit 1
timezone=$(timedatectl list-timezones | /usr/bin/fzf --prompt "Enter Timezone: ") || exit 1
gpu=$(printf "amd\nnvidia" | /usr/bin/fzf --prompt "Enter GPU: ") || exit 1
display_server=$(printf "xorg\nwayland\nnone" | /usr/bin/fzf --prompt "Enter Display Server: ") || exit 1
app_suite="n"
if ! [ "$display_server" = "none" ]; then
    app_suite=$(input_confirm "Install Application Suite?(y/N)") || exit 1
fi

echo "------------------------"
echo "DISK PARTITIONING"
echo "------------------------"

if [ "$swap" = "y" ]; then
    ram_size=$(free -h --si | grep Mem | tr -s ' ' | cut -d' ' -f2)

    if [ -z "$ram_size" ]; then
        ram_size=$(input_notnull "Enter total RAM space number only (GB): ") || exit 1
    fi

    fdisk "$disk" > /dev/null << EOF
g
n


+1G
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

else
    fdisk "$disk" > /dev/null << EOF
g
n


+1G
n



t
1
1
w
EOF
fi

echo "------------------------"
echo "FORMATTING"
echo "------------------------"

if [ "$swap" = "y" ]; then
    boot_part=$(part "$disk" 1)
    swap_part=$(part "$disk" 2)
    root_part=$(part "$disk" 3)

    mkfs.fat -F32 "$boot_part" > /dev/null
    mkswap "$swap_part" > /dev/null
    
    if [ "$filesystem" = "ext4" ]; then
        mkfs.ext4 "$root_part" > /dev/null
    elif [ "$filesystem" = "btrfs" ]; then
        echo "BTRFS is not yet supported, falling back to Ext4"
        mkfs.ext4 "$root_part" > /dev/null
    fi

    umount /mnt/boot || true
    umount /mnt || true

    mount --mkdir "$root_part" /mnt
    mount --mkdir "$boot_part" /mnt/boot
    swapon "$swap_part"
else
    boot_part=$(part "$disk" 1)
    root_part=$(part "$disk" 2)

    mkfs.fat -F32 "$boot_part" > /dev/null
    
    if [ "$filesystem" = "ext4" ]; then
        mkfs.ext4 "$root_part" > /dev/null
    elif [ "$filesystem" = "btrfs" ]; then
        echo "BTRFS is not yet supported, falling back to Ext4"
        mkfs.ext4 "$root_part" > /dev/null
    fi

    umount /mnt/boot || true
    umount /mnt || true

    mount --mkdir "$root_part" /mnt
    mount --mkdir "$boot_part" /mnt/boot
fi

echo "------------------------"
echo "BASIC INSTALLS"
echo "------------------------"

pacman -Syy --noconfirm --needed > /dev/null
pacstrap -K /mnt base linux linux-firmware base-devel git fzf micro zsh

echo "------------------------"
echo "GENERATE FS TABLE"
echo "------------------------"

echo "" > /mnt/etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

echo "------------------------"
echo "GET DOTS"
echo "------------------------"

if ! [ -e /mnt/dotfiles ]; then
    /usr/bin/git clone https://github.com/dragonfly1033/dotfiles.git /mnt/dotfiles > /dev/null
    chmod +x /mnt/dotfiles/install/*
fi

echo "------------------------"
echo "CHROOT"
echo "------------------------"


arch-chroot /mnt /bin/bash -c '
export disk='"$disk"'
export swap='"$swap"'
export filesystem='"$filesystem"'
export root_passwd='"$root_passwd"'
export username='"$username"'
export user_passwd='"$user_passwd"'
export hostname='"$hostname"'
export timezone='"$timezone"'
export gpu='"$gpu"'
export display_server='"$display_server"'
export app_suite='"$app_suite"'
/dotfiles/install/chroot.sh
'

umount /mnt/boot
umount /mnt
reboot
