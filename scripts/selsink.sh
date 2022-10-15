#!/usr/bin/env bash

choosed=$(pactl list short | grep output | grep -v monitor | awk '{print $2}' | sed -e 1b -e '$!d' | dmenu -i -fn "FantasqueSansMono Nerd Font:size=12" -nb "#1d1fd2" -nf "#ffffff" -sb "#e44eaf" -sf "#eeeeee")

pactl set-default-sink $choosed
