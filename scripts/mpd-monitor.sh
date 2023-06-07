#!/usr/bin/sh

previous_sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')

while true; do
    current_sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')
    
    if [[ "$current_sink" != "$previous_sink" ]]; then
        mpc -q pause
	exit 0
    fi
    
    previous_sink=$current_sink
    sleep 0.1
done

