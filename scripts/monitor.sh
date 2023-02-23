#!/usr/bin/env bash

current=$(xrandr | grep -w "connected primary" | awk '{ print $1 }')
others=$(xrandr | grep -w connected | grep -v primary | awk '{ print $1 }')
selected=$(echo $others | dmenu)

xrandr --output $selected --off
xrandr --output $selected --mode 1920x1080 --$(printf "left-of\nright-of\nabove\nbelow\nsame-as" | dmenu) $current
~/.fehbg
