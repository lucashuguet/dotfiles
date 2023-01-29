#!/usr/bin/env bash

clipster -o -n 5 -m ";delimiter;" | tr "\n" " " | sed "s/;delimiter;/\n/g" | dmenu -l 5 -p "Clipboard" | xclip -sel clip
