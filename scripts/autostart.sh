#!/usr/bin/env sh

xrandr --output eDP-1 --mode 1920x1080 --rate 60 &
~/.fehbg &
pipewire &
pipewire-pulse &
wireplumber &
picom --config ~/.config/picom/picom-blur.conf &
launch-dunst.sh &
nm-applet &
bar.sh &
emacs --daemon &
