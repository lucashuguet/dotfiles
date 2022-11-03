#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

feh --no-fehbg --bg-fill '/home/astrogoat/dotfiles/wallpaper/gobacktothefuture.png' &
picom --config ~/.config/picom/picom-blur.conf --experimental-backends &
dunst &
flameshot &
nm-applet &
blueman-applet &
pasystray &
emacs --daemon &
~/dotfiles/scripts/bar.sh &
