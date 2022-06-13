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
ln -sf $dotfiles/alacritty ~/.config/
ln -sf $dotfiles/fish ~/.config/
ln -sf $dotfiles/mc ~/.config/
ln -sf $dotfiles/mpv ~/.config/
ln -sf $dotfiles/neofetch ~/.config/
ln -sf $dotfiles/picom ~/.config/
ln -sf $dotfiles/qtile ~/.config/
ln -sf $dotfiles/qutebrowser ~/.config/
ln -sf $dotfiles/ranger ~/.config/
ln -sf $dotfiles/nwg-launchers ~/.config
ln -sf $dotfiles/dunst ~/.config
ln -sf $dotfiles/.doom.d ~
ln -sf $dotfiles/starship.toml ~/.config/

sudo cp -r $dotfiles/sddm /usr/share/
sudo cp -r $dotfiles/sddm.conf.d /etc/
sudo cp $dotfiles/sddm.conf /etc/
sudo cp $dotfiles/30-touchpad.conf /etc/X11/xorg.conf.d/
sudo cp $dotfiles/alsa-base.conf /etc/modprobe.d/

mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/fonts

cp -r $dotfiles/icons/* ~/.local/share/icons
cp -r $dotfiles/themes/* ~/.local/share/themes
cp $dotfiles/fonts/* ~/.local/share/fonts

sudo ln -s ~/.local/share/icons/Sweet-cursors /usr/share/icons
sudo ln -s ~/.local/share/themes/Sweet-Dark-v40 /usr/share/themes

# some other settings

localectl set-x11-keymap fr
systemctl enable --user pipewire pipewire-pulse
sudo systemctl enable NetworkManager bluetooth sddm

~/.emacs.d/bin/doom install

cd $dotfiles/aur/nwg-launchers && makepkg -si
cd $dotfiles/aur/find-the-command && makepkg -si
cd $dotfiles/aur/sweet-dark-theme && makepkg -si
cd $dotfiles/aur/tela-icon-theme && makepkg -si

chsh -s /bin/fish
sudo chsh -s /bin/fish
