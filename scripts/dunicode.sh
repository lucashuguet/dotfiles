#!/usr/bin/env sh

cat ~/dotfiles/scripts/unicode.txt | dmenu -i -l 20 -g 6 -fn 'noto-cjk' | awk '{ print $1 }' | tr -d "\n" | xclip -selection clipboard
notify-send "$(xclip -o -selection clipboard) copied to clipboard"
