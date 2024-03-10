#!/bin/sh

read -p 'Enter System Size (f)ull, (m)inimal: ' size
while [ "$size" != "f" ] && [ "$size" != "m" ]; do
	echo "Please enter a valid input."
	read -p 'Enter System Size (f)ull, (m)inimal: ' size
done

echo "--------------------------------------------------------------------------------------"
echo "INSTALL AUR PKGS"
echo "--------------------------------------------------------------------------------------"

if [ "$size" = "f" ]; then
    yes '
    ' | yay -S --sudoloop --needed --mflags "--noconfirm" $(cat ~/.dotfiles/install/yay_pkgs | xargs)
elif [ "$size" = "m" ]; then
    yes '
    ' | yay -S --sudoloop --needed --mflags "--noconfirm" $(cat ~/.dotfiles/install/yay_min_pkgs | xargs)
fi


git clone https://github.com/elkowar/eww ~/eww
cd eww
cargo build --release --no-default-features --features x11
cd target/release
chmod +x eww
mv eww ~/.local/bin
cd
rm -rf eww