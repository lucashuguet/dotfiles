#!/bin/sh

# Variables
dotfiles=~/dotfiles

# Installing requirements
sudo pacman -Syu --needed \
    alacritty \
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
    pasystray \
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
    pipewire{pulse,alsa,jack} \
    plasma-framework \
    xorg \
    nvidia \
    sddm \
    dmenu \
    mpv \
    p7zip \
    python-pip \
    adobe-source-code-pro-fonts \
    awesome-terminal-fonts \
    noto-fonts \
    noto-fonts-cjk \
    python-psutil \
    pavucontrol \
    networkmanager \
    network-manager-applet \
    flameshot \
    find-the-command \
    r8168

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
git clone https://aur.archlinux.org/nwg-launchers.git $dotfiles/aur
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

cp -r $dotfiles/icons/* ~/.local/share/icons
cp -r $dotfiles/themes/* ~/.local/share/themes
sudo ln -s ~/.local/share/icons/Sweet-cursors /usr/share/icons

mkdir -p ~/.local/share/fonts

cp $dotfiles/fonts/* ~/.local/share/fonts

# some other settings

localectl set-x11-keymap fr
systemctl enable --user pipewire pipewire-pulse
sudo systemctl enable NetworkManager bluetooth

~/.emacs.d/bin/doom install
cd $dotfiles/aur/nwg-launchers && makepkg -si
sudo chsh -s /bin/fish
