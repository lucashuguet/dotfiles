#!/bin/sh

# Variables
dotfiles=~/dotfiles

# Installing requirements
sudo pacman -Syu alacritty fish mc mpv neofetch picom qtile qutebrowser ranger starship firefox emacs neovim nitrogen
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Delete existing dotfiles/folders

# sudo rm -rf ~/.Xressources
# sudo rm -rf ~/.Xauthority
sudo rm -rf ~/.spacemacs
sudo rm -rf ~/.spacemacs.env
sudo rm -rf ~/.config/
sudo rm -rf ~/.doom.d/
# sudo rm -rf ~/.emacs.d/

# Creating links

mkdir ~/.config
ln -sf $dotfiles/alacritty ~/.config/alacritty
ln -sf $dotfiles/fish ~/.config/fish
ln -sf $dotfiles/mc ~/.config/mc
ln -sf $dotfiles/mpv ~/.config/mpv
ln -sf $dotfiles/neofetch ~/.config/neofetch
ln -sf $dotfiles/picom ~/.config/picom
ln -sf $dotfiles/qtile ~/.config/qtile
ln -sf $dotfiles/qutebrowser ~/.config/qutebrowser
ln -sf $dotfiles/ranger ~/.config/ranger
ln -sf $dotfiles/.doom.d ~/.doom.d
ln -sf $dotfiles/starship.toml ~/.config/starship.toml

~/.emacs.d/bin/doom install
sudo chsh -s /bin/fish
