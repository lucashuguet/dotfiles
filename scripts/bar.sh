typeset -i iProcNr="$$"
typeset    fPIDFile="/tmp/bar.pid"

if [ -f "$fPIDFile" ] ; then
     echo "script already running, exiting."
     exit 1
else
     echo "$iProcNr" > "$fPIDFile"
fi

while true
do

        battery=$(cat /sys/class/power_supply/BAT0/capacity)
        cpu=$(top -bin 1 | sed -n '3 p' | awk '{print $2}')
        mem=$(printf %.0f $(top -bin 1 | sed -n '4 p' | awk '{print $8}'))

        # wifi=$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | sed 's/yes://')
        # test "$wifi" == "" && wifi="na"

        time=$(date +"%R:%S")
        day=$(date +"%a %d %b")

        bar="[💻 $cpu% ] [💾 $mem Mib] [🔋 $battery ] [📅 $day] [🕐 $time ]"
        xsetroot -name "$bar"

        sleep 1
done
