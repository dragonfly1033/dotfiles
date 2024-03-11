#!/bin/sh

username=$(whoami)

sed -r '/install_post/ d' -i /home/$username/.bashrc

echo "--------------------------------------------------------------------------------------"
echo "CHANGE TO ZSH"
echo "--------------------------------------------------------------------------------------"

mkdir -p /home/$username/.local/state/zsh

su --command="chsh -s /bin/zsh" $username


/home/$username/.dotfiles/install/install_yay.sh
/home/$username/.dotfiles/install/install_firefox_patch.sh
/home/$username/.dotfiles/install/install_vscodium.sh
/home/$username/.dotfiles/install/install_yay_pkgs.sh