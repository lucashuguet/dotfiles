#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}



#starting utility applications at boot time
lxsession &
run nm-applet &
blueman-applet &
flameshot &
picom --config .config/picom/picom-blur.conf --experimental-backends &
dunst &
# feh -bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png
pasystray &
nitrogen --restore &
emacs --daemon &
