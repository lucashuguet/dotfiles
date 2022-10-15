#!/usr/bin/env bash

echo -e "poweroff\nreboot\nsuspend" | dmenu -i -fn "FantasqueSansMono Nerd Font:size=12" -nb "#1d1fd2" -nf "#ffffff" -sb "#e44eaf" -sf "#eeeeee" | xargs systemctl
