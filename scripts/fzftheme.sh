#!/usr/bin/env sh

if [ $# -eq 0 ]
  then
    path=~/Pictures/wallpapers/
  else
    path=$1/
fi

file=$(cd $path && fzfimg.sh)
if [ $? == 1 ]; then	
	notify-send "dmenutheme" "abort"
	exit 0
else
	if [ "$file" = "default" ]; then
		xrdb -remove
		xrdb ~/dotfiles/scripts/dmenu.Xresources

		feh --bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png

		kill -9 $(top -bcn 1 | grep autostart.sh | sed 1q | awk '{print $1}')
		xdotool key super+r
	
		systemctl restart --user emacs.service
		# emacsclient -ce "(load-theme 'doom-palenight t)"

		notify-send "dmenutheme" "default theme loaded"

		exit 0
	else
		echo $file
		settheme.sh "$path$file"
		notify-send "dmenutheme" "$file theme loaded"
	fi
fi

