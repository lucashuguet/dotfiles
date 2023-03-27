#!/usr/bin/env sh

~/.fehbg &
pipewire &
pipewire-pulse &
wireplumber &
picom --config ~/.config/picom/picom-blur.conf &
launch-dunst.sh &
nm-applet &
bar.sh &
emacs --daemon &
