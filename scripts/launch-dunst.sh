#!/usr/bin/env sh

CONFIG_FILES="$HOME/.config/dunst/dunstrc $HOME/.config/dunst/colors"

trap "killall dunst" EXIT

while true; do
    cat ~/.config/dunst/dunstrc ~/.config/dunst/colors | dunst -conf - &
    inotifywait -e create,modify $CONFIG_FILES
    killall dunst
done
