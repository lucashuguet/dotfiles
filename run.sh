#!/bin/sh

# Variables
dotfiles=~/dotfiles

# Install yay
git clone https://aur.archlinux.org/yay.git $dotfiles/aur/yay
cd $dotfiles/aur/yay && makepkg -si

# Installing requirements
yay -Syu --needed - < pkg.txt

rm -rf ~/.emacs.d
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Delete existing dotfiles/folders
sudo rm -rf ~/.spacemacs
sudo rm -rf ~/.spacemacs.env
sudo rm -rf ~/.config/
sudo rm -rf ~/.doom.d/
sudo rm -rf /etc/sddm*
sudo rm -rf /usr/share/sddm/

# Creating links
mkdir ~/.config

ln -sf $dotfiles/config/* ~/.config/
ln -sf $dotfiles/home/* ~

sudo cp -r $dotfiles/sys/sddm /usr/share/
sudo cp -r $dotfiles/sys/sddm.conf.d /etc/
sudo cp $dotfiles/sys/sddm.conf /etc/
sudo cp $dotfiles/sys/30-touchpad.conf /etc/X11/xorg.conf.d/
sudo cp $dotfiles/sys/alsa-base.conf /etc/modprobe.d/

# Some other settings
localectl set-x11-keymap fr
systemctl enable --user pipewire pipewire-pulse
sudo systemctl enable NetworkManager bluetooth sddm

~/.emacs.d/bin/doom install

$dotfiles/scripts/audio.sh

chsh -s /bin/fish
sudo chsh -s /bin/fish
