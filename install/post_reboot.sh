#!/bin/sh

set -e

get_packages () {
    cat ~/.dotfiles/install/packages.csv | grep -E ".*,$1,.*$2.*,$3" | cut -d',' -f1 | xargs
}

error="required variable not set, must be run from start_install.sh"
disk="${disk:?$error}"
swap="${swap:?$error}"
filesystem="${filesystem:?$error}"
root_passwd="${root_passwd:?$error}"
username="${username:?$error}"
user_passwd="${user_passwd:?$error}"
hostname="${hostname:?$error}"\
timezone="${timezone:?$error}"
gpu="${gpu:?$error}"
display_server="${display_server:?$error}"
machine="${machine:?$error}"
app_suite="${app_suite:?$error}"


echo "------------------------"
echo "INSTALL YAY PKGS"
echo "------------------------"

yay_install () {
      pkgs=$(get_packages yay "$1" "$2")

      [ -n "$pkgs" ] || return 0

      for pkg in $pkgs; do
          echo "Installing AUR package: $pkg"

          yay -S --aur \
              --needed \
              --noconfirm \
              --sudoloop \
              --removemake \
              --cleanafter \
              --answerclean All \
              --answerdiff None \
              --answeredit None \
              --mflags "--noconfirm" \
              "$pkg"
      done
}

yay_install ".*" cli

if [ "$display_server" = "xorg" ]; then
    yay_install xorg gui_light
    if [ "$app_suite" = "y" ]; then
        yay_install xorg gui_heavy
    fi
elif [ "$display_server" = "wayland" ]; then
    yay_install wayland gui_light
    if [ "$app_suite" = "y" ]; then
        yay_install wayland gui_heavy
    fi
fi

echo "------------------------"
echo "INSTALL VSCODIUM EXTENTIONS"
echo "------------------------"

if pacman -Qe | grep -q vscodium; then
    /usr/bin/vscodium --install-extension albymor.increment-selection || true
    /usr/bin/vscodium --install-extension Catppuccin.catppuccin-vsc || true
    /usr/bin/vscodium --install-extension DrMerfy.overtype || true
    /usr/bin/vscodium --install-extension earshinov.simple-alignment || true
    /usr/bin/vscodium --install-extension James-Yu.latex-workshop || true
    /usr/bin/vscodium --install-extension mads-hartmann.bash-ide-vscode || true
    /usr/bin/vscodium --install-extension MattPerlick.markdown-preview-editor || true
    /usr/bin/vscodium --install-extension medo64.render-crlf || true
    /usr/bin/vscodium --install-extension moshfeu.diff-merge || true
    /usr/bin/vscodium --install-extension ms-python.python || true
    /usr/bin/vscodium --install-extension PKief.material-icon-theme || true
    /usr/bin/vscodium --install-extension ritwickdey.LiveServer || true
    /usr/bin/vscodium --install-extension sdras.night-owl || true
    /usr/bin/vscodium --install-extension shd101wyy.markdown-preview-enhanced || true
    /usr/bin/vscodium --install-extension zaaack.markdown-editor || true
fi

echo "------------------------"
echo "PATCH FIREFOX"
echo "------------------------"

if pacman -Qe | grep -q firefox; then
    firefox --headless &

    sleep 4

    for i in $(find ~ -maxdepth 3 -type d -path "/home/$username/.mozilla/firefox/*.*"); do
        cp -r ~/.dotfiles/files/firefox/chrome "$i"/chrome
        rm -rf "$i"/startupCache/*
        cat ~/.dotfiles/files/firefox/user.js >> "$i"/prefs.js
    done

    sudo cp -r ~/.dotfiles/files/firefox/defaults "/usr/lib/firefox"
    sudo cp ~/.dotfiles/files/firefox/config.js /usr/lib/firefox
    sudo cp ~/.dotfiles/files/firefox/config-prefs.js /usr/lib/firefox/defaults/pref

    sleep 2

    pkill firefox || true
fi

echo "------------------------"
echo "CLEANUP HOOK"
echo "------------------------"

sed -r '/# START HOOK/,/# END HOOK/d' -i "/home/$username/.zshrc"

# systemctl disable post-reboot-install.service
# rm -f /etc/systemd/system/post-reboot-install.service
# systemctl daemon-reload

echo "------------------------"
echo "DONE!!!!!!!!!!!!!!!!"
echo "------------------------"
