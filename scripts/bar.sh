while true
do

        battery=$(cat /sys/class/power_supply/BAT0/capacity)
        cpu=$(top -bin 1 | sed -n '3 p' | awk '{print $2}')
        mem=$(printf %.0f $(top -bin 1 | sed -n '4 p' | awk '{print $8}'))

        # wifi=$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | sed 's/yes://')
        # test "$wifi" == "" && wifi="na"

        time=$(date +"%a %d/%m %R:%S")

        bar="CPU: $cpu% | RAM: $mem Mib |🔋: $battery | $time"
        xsetroot -name "$bar"

        sleep 1
done
