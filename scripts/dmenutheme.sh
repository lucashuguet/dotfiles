#!/usr/bin/env sh

file=$(ls ~/Pictures/wallpapers/ | sed "s/.png$//g" | dmenu)
if [ $? == 1 ]
then
	xrdb -remove
	feh --bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png
	killall autostart.sh
	xdotool key super+r
	exit
fi

settheme.sh "/home/astrogoat/Pictures/wallpapers/$file.png"
