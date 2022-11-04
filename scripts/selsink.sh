#!/usr/bin/env bash

choosed=$(pactl list short | grep output | grep -v monitor | awk '{print $2}' | sed -e 1b -e '$!d' | dmenu -i")

pactl set-default-sink $choosed
