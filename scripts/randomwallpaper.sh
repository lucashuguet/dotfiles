#!/usr/bin/env sh

rm ~/Pictures/wallpapers/random-wallpaper.png
wget https://unsplash.it/3840/2160/?random -O ~/Pictures/wallpapers/random-wallpaper.png
wal -c
~/dotfiles/scripts/settheme.sh ~/Pictures/wallpapers/random-wallpaper.png
