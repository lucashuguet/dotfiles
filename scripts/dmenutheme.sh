#!/usr/bin/env sh

file=$(ls ~/Pictures/wallpapers/ | sed "s/.png$//g" | dmenu -i)
if [ $? == 1 ]; then
	exit 0
else
	if [ "$file" = "default" ]; then
		xrdb -remove
		feh --bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png
		killall autostart.sh
		xdotool key super+r
		exit 0
	else
		echo $file
		settheme.sh "/home/astrogoat/Pictures/wallpapers/$file.png"
	fi
fi

