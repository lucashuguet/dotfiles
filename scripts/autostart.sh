#!/usr/bin/env sh

~/.fehbg &
picom --config ~/.config/picom/picom-blur.conf --experimental-backends &
dunst &
flameshot &
nm-applet &
blueman-applet &
pasystray &
emacs --daemon &
bar.sh &
