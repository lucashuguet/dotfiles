#!/bin/sh

# Variables
dotfiles=~/dotfiles

# Installing requirements
sudo pacman -Syu alacritty \
    fish \
    mc \
    mpv \
    neofetch \
    picom \
    qtile \
    qutebrowser \
    ranger \
    starship \
    firefox \
    emacs \
    neovim \
    nitrogen \
    feh \
    volumeicon \
    numlockx \
    blueman \
    lxappearance \
    lxsession \
    dunst \
    exa \
    bat \
    nitrogen \
    mcfly \
    dolphin \
    alsa \
    alsa-utils \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    plasma-network \
    xorg \
    nvidia \
    sddm \
    dmenu \
    mpv \
    p7zip \
    python-pip \
    nwg-launchers \
    adobe-source-code-pro-fonts \
    awesome-terminal-fonts \
    noto-fonts \
    noto-fonts-cjk

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

sudo cp -r $dotfiles/sddm /usr/share/
sudo cp -r $dotfiles/sddm.conf.d /etc/
sudo cp $dotfiles/sddm.conf /etc/

mkdir ~/.icons
mkdir ~/.themes

cp -r $dotfiles/icons/* ~/.icons
cp -r $dotfiles/themes/* ~/.themes

mkdir -p ~/.local/share/fonts

cp $dotfiles/fonts/* ~/.local/share/fonts

~/.emacs.d/bin/doom install
sudo chsh -s /bin/fish
