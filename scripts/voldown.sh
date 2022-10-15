#!/usr/bin/env bash

pactl set-sink-volume $(pactl get-default-sink) -5%
