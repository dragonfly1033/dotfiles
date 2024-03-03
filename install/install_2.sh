#!/bin/sh

echo "--------------------------------------------------------------------------------------"
echo "INSTALL PROGRAMS"
echo "--------------------------------------------------------------------------------------"

sudo pacman -S --noconfirm --needed "$(cat /dotfiles/install/pac_pkgs | xargs)" > /dev/null


read alskdn

echo "--------------------------------------------------------------------------------------"
echo "Remove legacy graphics driver"
echo "--------------------------------------------------------------------------------------"

sudo pacman -Rns --noconfirm xf86-video-vesa > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "LOGIN & SPLASH"
echo "--------------------------------------------------------------------------------------"

sudo pacman -S --noconfirm --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan plymouth

sudo cp /dotfiles/files/lightdm-plymouth.service /usr/lib/systemd/system
sudo mkdir /usr/share/backgrounds
sudo cp /dotfiles/files/black_background.png /usr/share/backgrounds
sudo cp -r "/dotfiles/files/plymouth_themes/*" /usr/share/plymouth/themes

# sed -i '/#animate/c\animate=false' /etc/ly/config.ini
# sed -i '/#asterisk/c\asterisk=o' /etc/ly/config.ini
# sed -i '/#margin_box_w/c\margin_box_w=6' /etc/ly/config.ini
# sed -i '/#margin_box_h/c\margin_box_h=25' /etc/ly/config.ini
# sed -i '/#blank_password/c\blank_password=true' /etc/ly/config.ini

sudo sed -ri 's/^#?greeter-session=.*/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
sudo sed -ri 's/^#?webkit_theme.*/webkit_theme=litarvan/' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -ri 's/^#?debug_mode.*/debug_mode=true/' /etc/lightdm/lightdm-webkit2-greeter.conf

sudo sed -ri 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 splash udev.log_level=3 rd.udev.log_level=3 loglevel=3 vt.global_cursor_default=0"/' /etc/default/grub
sudo sed -ri 's/^#?GRUB_DEFUALT=.*/GRUB_DEFAULT=0/' /etc/default/grub
sudo sed -ri 's/^#?GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo echo "GRUB_RECORDFAIL_TIMEOUT=\$GRUB_TIMEOUT" > /etc/default/grub
 
sudo sed -ri 's/MODULES=\((.*)\)$/MODULES=\(\1 amdgpu\)/' /etc/mkinitcpio.conf
sudo sed -ri 's/HOOKS=\(base udev (.*)\)/HOOKS=\(base udev plymouth \1\)/' /etc/mkinitcpio.conf   

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo systemctl enable lightdm-plymouth.service

sudo plymouth-set-default-theme -R rings > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "XORG CONFS"
echo "--------------------------------------------------------------------------------------"

sudo cp /dotfiles/files/50-touchpad.conf /etc/X11/xorg.conf.d
sudo chmod +xr /etc/X11/xorg.conf.d/50-touchpad.conf
sudo cp /dotfiles/files/40-libinput.conf /usr/share/X11/xorg.conf.d
sudo chmod +xr /usr/share/X11/xorg.conf.d/40-libinput.conf
sudo cp /dotfiles/files/10-amdgpu.conf /usr/share/X11/xorg.conf.d
sudo chmod +xr /usr/share/X11/xorg.conf.d/10-amdgpu.conf

echo "--------------------------------------------------------------------------------------"
echo "MOVE SYSTEM FILES"
echo "--------------------------------------------------------------------------------------"

sudo cp /dotfiles/files/pfetch /usr/bin
# cp /dotfiles/files/ly/config.ini /etc/ly

echo "--------------------------------------------------------------------------------------"
echo "CRON"
echo "--------------------------------------------------------------------------------------"

sudo sed -i "s/USER/$username/g" /dotfiles/files/cron/user
sudo sed -i "s/USER/$username/g" /dotfiles/files/cron/root

sudo crontab -u $username /dotfiles/files/cron/user
sudo crontab -u root /dotfiles/files/cron/root

echo "--------------------------------------------------------------------------------------"
echo "CHANGE PERMS"
echo "--------------------------------------------------------------------------------------"

sudo chmod +x /dotfiles/home/bin
sudo chmod +x "/dotfiles/home/*"
sudo chmod -R +x /dotfiles/.config

echo "--------------------------------------------------------------------------------------"
echo "RELOCATE DOTS"
echo "--------------------------------------------------------------------------------------"

sudo chown -R $username /dotfiles
sudo chgrp -R $username /dotfiles

sudo mv /dotfiles /home/$username/.dotfiles

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

git clone "https://github.com/BlingCorp/bling.git" "/home/$username/.config/awesome/bling" > /dev/null

echo "--------------------------------------------------------------------------------------"
echo "MOVE FONTS"
echo "--------------------------------------------------------------------------------------"

mkdir -p ~/.local/share/fonts/MyFonts
sudo ln -s "/home/$username/.dotfiles/fonts/*" "/home/$username/.local/share/fonts/MyFonts"

echo "--------------------------------------------------------------------------------------"
echo "INSTALL YAY"
echo "--------------------------------------------------------------------------------------"

git clone https://aur.archlinux.org/yay-bin.git > /dev/null
cd yay-bin
makepkg -si > /dev/null
cd
rm -rf yay-bin

echo "--------------------------------------------------------------------------------------"
echo "INSTALL AUR PKGS"
echo "--------------------------------------------------------------------------------------"

yes '
' | yay -S --needed --mflags "--noconfirm" "$(cat ~/.dotfiles/install/yay_pkgs | xargs)"


