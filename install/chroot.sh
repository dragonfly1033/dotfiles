#!/bin/sh

set -e

install_aur () {
    AUR_PKG="$1"
    AUR_URL="https://aur.archlinux.org/${AUR_PKG}.git"
    AUR_BUILD_ROOT="${AUR_BUILD_ROOT:-/var/tmp}"
    BUILD_DIR="${AUR_BUILD_ROOT}/aur-build-${AUR_PKG}"
    AUR_TMPDIR="${TMPDIR:-/var/tmp}"
    AUR_NPM_CACHE="${AUR_NPM_CACHE:-/var/tmp/aur-npm-cache}"

    rm -rf "$BUILD_DIR" > /dev/null
    mkdir -p "$AUR_BUILD_ROOT" "$AUR_TMPDIR" "$AUR_NPM_CACHE" > /dev/null
    chmod 1777 "$AUR_BUILD_ROOT" "$AUR_TMPDIR" > /dev/null
    mkdir -p "$BUILD_DIR" > /dev/null
    chown -R "aurbuilder:aurbuilder" "$BUILD_DIR" "$AUR_NPM_CACHE" > /dev/null

    runuser -u "aurbuilder" -- git clone "$AUR_URL" "$BUILD_DIR" > /dev/null

    # Build as non-root.
    runuser -u "aurbuilder" -- sh -c "cd '$BUILD_DIR' && TMPDIR='$AUR_TMPDIR' npm_config_cache='$AUR_NPM_CACHE' makepkg -sr --needed --noconfirm"

    # build packages as root
    pacman -U --noconfirm "$BUILD_DIR"/*.pkg.tar.*

    rm -rf "$BUILD_DIR"
}

get_packages () {
    cat /dotfiles/install/packages.csv | grep -E ".*,$1,.*$2.*,$3" | cut -d',' -f1 | xargs
}


error="required variable not set, must be run from start_install.sh"
disk="${disk:?$error}"
swap="${swap:?$error}"
filesystem="${filesystem:?$error}"
root_passwd="${root_passwd:?$error}"
username="${username:?$error}"
user_passwd="${user_passwd:?$error}"
hostname="${hostname:?$error}"
timezone="${timezone:?$error}"
gpu="${gpu:?$error}"
display_server="${display_server:?$error}"
machine="${machine:?$error}"
app_suite="${app_suite:?$error}"

echo "------------------------"
echo "ROOT password"
echo "------------------------"

echo "root:$root_passwd" | chpasswd
passwd -l root

echo "------------------------"
echo "USER setup"
echo "------------------------"

useradd -m "$username" > /dev/null
echo "$username:$user_passwd" | chpasswd
usermod -aG wheel,audio,video,optical,storage "$username" > /dev/null
usermod -s /usr/bin/zsh "$username"

echo "------------------------"
echo "CLOCK, TIMEZONE & LOCALE"
echo "------------------------"

ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime > /dev/null
hwclock --systohc > /dev/null

sed -i '/en_GB.UTF-8/s/^#//g' /etc/locale.gen
locale-gen > /dev/null

echo "------------------------"
echo "HOSTS & CONSTS"
echo "------------------------"

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "$hostname" >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   $hostname.localdomain   $hostname" >> /etc/hosts

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

echo "------------------------"
echo "INSTALL ESSENTIALS"
echo "------------------------"

rm -rf /etc/pacman.d/gnupg
pacman-key --init > /dev/null
pacman-key --populate archlinux > /dev/null

pacman -Syyu --noconfirm --needed > /dev/null
pacman -S --noconfirm --needed micro sudo grub efibootmgr dosfstools os-prober mtools > /dev/null

if [ "$gpu" = "amd" ]; then
    pacman -S --noconfirm --needed xf86-video-amdgpu mesa vulkan-radeon > /dev/null
elif [ "$gpu" = "nvidia" ]; then
    echo "NVidia GPU's not yet supported"
    exit 1
fi

echo "------------------------"
echo "INSTALL AUR PACKAGES"
echo "------------------------"

aur_diagnostics() {
    status="$1"

    echo "AUR build failed with status $status"
    echo "Keeping aurbuilder, /var/tmp/aur-build-*, and /var/tmp/aur-npm-cache for inspection."
    echo "Run this from the live system to inspect it again: arch-chroot /mnt"
    echo "Remove leftovers later with: userdel -r aurbuilder; rm -rf /var/tmp/aur-build-* /var/tmp/aur-npm-cache"
    echo "------------------------"
    echo "DISK SPACE"
    echo "------------------------"
    df -hT / /tmp /var/tmp /home/aurbuilder /run /dev/shm 2>/dev/null || true
    echo "------------------------"
    echo "INODES"
    echo "------------------------"
    df -ih / /tmp /var/tmp /home/aurbuilder /run /dev/shm 2>/dev/null || true
    echo "------------------------"
    echo "MOUNTS"
    echo "------------------------"
    for path in / /tmp /var/tmp /home/aurbuilder /run /dev/shm; do
        findmnt -T "$path" -o TARGET,SOURCE,FSTYPE,SIZE,AVAIL,OPTIONS 2>/dev/null || true
    done
}

cleanup_aur() {
    rm -f /etc/sudoers.d/temp_aur_builder_perms

    if id aurbuilder >/dev/null 2>&1; then
        userdel -r aurbuilder >/dev/null 2>&1 || true
    fi

    rm -rf /var/tmp/aur-build-* /var/tmp/aur-npm-cache
}

finish_aur() {
    status="$1"

    if [ "$status" -eq 0 ]; then
        cleanup_aur
    else
        rm -f /etc/sudoers.d/temp_aur_builder_perms
        aur_diagnostics "$status"
    fi
}
trap 'status=$?; finish_aur "$status"; exit "$status"' EXIT

# create temp user with perms
useradd -m -r -s /bin/sh aurbuilder >/dev/null
echo "aurbuilder ALL=(root) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers.d/temp_aur_builder_perms
chmod 0440 /etc/sudoers.d/temp_aur_builder_perms >/dev/null

for pkg in yay-bin nody-greeter; do
    install_aur "$pkg"
done

cleanup_aur
trap - EXIT

echo "------------------------"
echo "INSTALL PROGRAMS"
echo "------------------------"

pacman_install () {
    pacman -S --noconfirm --needed $(get_packages pacman "$1" "$2")    
}

pacman_install ".*" cli

if [ "$display_server" = "xorg" ]; then
    pacman_install xorg gui_light
    if [ "$app_suite" = "y" ]; then
        pacman_install xorg gui_heavy
    fi
elif [ "$display_server" = "wayland" ]; then
    pacman_install wayland gui_light
    if [ "$app_suite" = "y" ]; then
        pacman_install wayland gui_heavy
    fi
fi

if [ "$machine" = "vbox" ]; then
    pacman -S --noconfirm --needed mesa xorg-xwayland xwayland-satellite virtualbox-guest-utils xf86-video-vesa vulkan-swrast vulkan-virtio
    systemctl enable vboxservice.service
fi

echo "------------------------"
echo "MOVE SYSTEM FILES"
echo "------------------------"

if [ "$display_server" = "xorg" ]; then
    cp /dotfiles/files/50-touchpad.conf /etc/X11/xorg.conf.d
    chmod +xr /etc/X11/xorg.conf.d/50-touchpad.conf
    cp /dotfiles/files/40-libinput.conf /usr/share/X11/xorg.conf.d
    chmod +xr /usr/share/X11/xorg.conf.d/40-libinput.conf
    cp /dotfiles/files/10-amdgpu.conf /usr/share/X11/xorg.conf.d
    chmod +xr /usr/share/X11/xorg.conf.d/10-amdgpu.conf
fi

cp /dotfiles/files/pfetch /usr/bin

echo "------------------------"
echo "SUDO setup"
echo "------------------------"

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/custom
echo "%wheel ALL=(ALL:ALL) NOPASSWD: /sbin/shutdown" >> /etc/sudoers.d/custom
echo "%wheel ALL=(ALL:ALL) NOPASSWD:SETENV: /usr/bin/plymouth-set-default-theme" >> /etc/sudoers.d/custom

chmod 0440 /etc/sudoers.d/custom

echo "------------------------"
echo "GRUB"
echo "------------------------"

sed -i '/#GRUB_DISABLE_OS_PROBER/c\GRUB_DISABLE_OS_PROBER=false' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub_uefi --recheck > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null

echo "------------------------"
echo "NETWORKING"
echo "------------------------"

pacman -S --noconfirm --needed networkmanager > /dev/null

systemctl enable NetworkManager > /dev/null

echo "------------------------"
echo "LOGIN & SPLASH"
echo "------------------------"

if ! [ "$display_server" = "none" ]; then
    pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan plymouth

    mkdir -p /usr/share/backgrounds
    cp /dotfiles/files/black_background.png /usr/share/backgrounds
    cp -r "/dotfiles/files/plymouth_themes"/* /usr/share/plymouth/themes

    sed -ri 's/^#?greeter-session=.*/greeter-session=nody-greeter/' /etc/lightdm/lightdm.conf
    sed -ri 's/^#?webkit_theme.*/webkit_theme=litarvan/' /etc/lightdm/lightdm-webkit2-greeter.conf
    sed -ri 's/^#?debug_mode.*/debug_mode=true/' /etc/lightdm/lightdm-webkit2-greeter.conf

    sed -ri 's/^( *theme:).*/\1 litarvan/' /etc/lightdm/web-greeter.yml
    sed -ri 's/^( *debug:).*/\1 True/' /etc/lightdm/web-greeter.yml
    sed -ri 's/^( *battery:).*/\1 True/' /etc/lightdm/web-greeter.yml

    sed -ri 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 splash udev.log_level=3 rd.udev.log_level=3 loglevel=3 vt.global_cursor_default=0"/' /etc/default/grub
    sed -ri 's/^#?GRUB_DEFAULT=.*/GRUB_DEFAULT=0/' /etc/default/grub
    sed -ri 's/^#?GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
    echo "GRUB_RECORDFAIL_TIMEOUT=\$GRUB_TIMEOUT" | tee -a /etc/default/grub
    
    sed -ri 's/MODULES=\((.*)\)$/MODULES=\(\1 amdgpu\)/' /etc/mkinitcpio.conf
    sed -ri 's/HOOKS=\(base udev (.*)\)/HOOKS=\(base udev plymouth \1\)/' /etc/mkinitcpio.conf   

    mkinitcpio -P

    grub-mkconfig -o /boot/grub/grub.cfg

    systemctl enable lightdm.service

    plymouth-set-default-theme -R rings > /dev/null
fi

echo "------------------------"
echo "CRON"
echo "------------------------"

sed -i "s/USER/$username/g" /dotfiles/files/cron/user
sed -i "s/USER/$username/g" /dotfiles/files/cron/root

crontab -u "$username" /dotfiles/files/cron/user
crontab -u root /dotfiles/files/cron/root

systemctl enable cronie

echo "------------------------"
echo "CHANGE PERMS"
echo "------------------------"

chmod +x /dotfiles/home/bin
chmod +x "/dotfiles/home"/*
chmod -R +x /dotfiles/.config

echo "------------------------"
echo "RELOCATE DOTS"
echo "------------------------"

chown -R "$username" /dotfiles
chgrp -R "$username" /dotfiles

mv /dotfiles "/home/$username/.dotfiles"

echo "------------------------"
echo "LINK DOTS"
echo "------------------------"

mkdir "/home/$username/Downloads" || true
mkdir "/home/$username/Documents" || true
mkdir "/home/$username/Desktop" || true
mkdir "/home/$username/Pictures" || true
mkdir "/home/$username/.config" || true

for i in "/home/$username/.dotfiles/.config"/*; do
    ln -sfn "$i" "/home/$username/.config"
done

for i in "/home/$username/.dotfiles/home"/*; do
    ln -sfn "$i" "/home/$username"
done

for i in "/home/$username/.dotfiles/home"/.*; do
    ln -sfn "$i" "/home/$username"
done

mkdir -p "/home/$username/.local/share/fonts"

for i in "/home/$username/.dotfiles/fonts"/*; do
    ln -sfn "$i" "/home/$username/.local/share/fonts"
done

ln -sfn "/home/$username/.dotfiles/wallpapers" "/home/$username/Pictures/wallpapers"

if [ "$display_server" = "xorg" ]; then
    sed "s!name=.*!name=\"$("/home/$username/bin/vars" get THEME)\"!" -i "/home/$username/.fehbg"
fi

echo "--------------------------------"
echo "Setup post-reboot install hook"
echo "--------------------------------"

echo "
# START HOOK
disk=\"$disk\" \\
swap=\"$swap\" \\
filesystem=\"$filesystem\" \\
root_passwd=\"$root_passwd\" \\
username=\"$username\" \\
user_passwd=\"$user_passwd\" \\
hostname=\"$hostname\" \\
timezone=\"$timezone\" \\
gpu=\"$gpu\" \\
display_server=\"$display_server\" \\
machine=\"$machine\" \\
app_suite=\"$app_suite\" \\
/home/$username/.dotfiles/install/post_reboot.sh
# END HOOK
" >> "/home/$username/.zshrc"

# echo "
# [Unit]
# Description=Continue installation after reboot
# After=network-online.target
# Wants=network-online.target

# [Service]
# Type=oneshot
# ExecStart=/dotfiles/install/post_reboot.sh
# RemainAfterExit=no
# Environment=\"disk=$disk\"
# Environment=\"swap=$swap\"
# Environment=\"filesystem=$filesystem\"
# Environment=\"root_passwd=$root_passwd\"
# Environment=\"username=$username\"
# Environment=\"user_passwd=$user_passwd\"
# Environment=\"hostname=$hostname\"
# Environment=\"timezone=$timezone\"
# Environment=\"gpu=$gpu\"
# Environment=\"display_server=$display_server\"
# Environment=\"machine=$machine\"
# Environment=\"app_suite=$app_suite\"

# [Install]
# WantedBy=multi-user.target
# " > /etc/systemd/system/post-reboot-install.service

# systemctl daemon-reload
# systemctl enable post-reboot-install.service
