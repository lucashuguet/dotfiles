#!/usr/bin/env bash

echo -e "poweroff\nreboot\nsuspend" | dmenu -i | xargs systemctl
