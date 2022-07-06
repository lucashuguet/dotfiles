#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom --config ~/.config/picom/picom-blur.conf --experimental-backends &
fi
