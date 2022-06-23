#!/usr/bin/env bash

pactl set-card-profile alsa_card.pci-0000_00_1f.3 pro-audio
pactl set-card-profile alsa_card.pci-0000_01_00.1 off
amixer set Capture nocap
