#!/usr/bin/env sh

# file=$(ls ~/Pictures/wallpapers/ | sed "s/.png$//g" | dmenu -p "Theme" -i)
file=$(ls /home/astrogoat/Pictures/wallpapers/*.png | sxiv -ftio)
if [ $? == 1 ]; then	
	notify-send "dmenutheme" "abort"
	exit 0
else
	if [ "$file" = "default" ]; then
		xrdb -remove
		xrdb ~/dotfiles/scripts/default.Xresources

		feh --bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png

		# kill -9 $(top -bcn 1 | grep autostart.sh | sed 1q | awk '{print $1}')
		xdotool key super+r
	
		systemctl restart --user emacs.service

		notify-send "dmenutheme" "default theme loaded"

		exit 0
	else
		echo $file
		# settheme.sh "/home/astrogoat/Pictures/wallpapers/$file.png"
		settheme.sh $file
		notify-send "dmenutheme" "$file theme loaded"
	fi
fi

