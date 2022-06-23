#!/bin/sh

# Variables
dotfiles=~/dotfiles

# Installing requirements
sudo pacman -Syu --needed - < pkg.txt

rm -rf ~/.emacs.d

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d

git clone https://aur.archlinux.org/nwg-launchers.git $dotfiles/aur/nwg-launchers
git clone https://aur.archlinux.org/find-the-command-git.git $dotfiles/aur/find-the-command
git clone https://aur.archlinux.org/sweet-dark-theme.git $dotfiles/aur/sweet-dark-theme
git clone https://aur.archlinux.org/tela-icon-theme.git $dotfiles/aur/tela-icon-theme
git clone https://aur.archlinux.org/sweet-cursors-theme-git.git $dotfiles/aur/sweet-cursors-theme-git
git clone https://aur.archlinux.org/sweet-kde-git.git $dotfiles/aur/sweet-kde-git

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
ln -sf $dotfiles/.doom.d ~

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

cd $dotfiles/aur/nwg-launchers && makepkg -si
cd $dotfiles/aur/find-the-command && makepkg -si
cd $dotfiles/aur/sweet-dark-theme && makepkg -si
cd $dotfiles/aur/tela-icon-theme && makepkg -si
cd $dotfiles/aur/sweet-cursors-theme-git && makepkg -si
cd $dotfiles/aur/sweet-kde-git && makepkg -si

$dotfiles/scripts/audio.sh

chsh -s /bin/fish
sudo chsh -s /bin/fish
