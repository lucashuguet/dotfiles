#!/usr/bin/env sh
wal -qntes -i "$1"
source ~/.cache/wal/colors.sh

feh --bg-fill $wallpaper

black=$color0
red=$color1
green=$color2
yellow=$color3
blue=$color4
magenta=$color5
cyan=$color6
white=$color7

lblack=$color8
lred=$(getlightcolor.py $red)
lgreen=$(getlightcolor.py $green)
lyellow=$(getlightcolor.py $yellow)
lblue=$(getlightcolor.py $blue)
lmagenta=$(getlightcolor.py $magenta)
lcyan=$(getlightcolor.py $cyan)
lwhite=$(getlightcolor.py $white)

lforeground=$white
lbackground=$color2

xres=~/.Xresources
alacritty=~/dotfiles/config/alacritty/colors.yml
qute=~/dotfiles/config/qutebrowser/colors.yml
hyprpaper=~/dotfiles/config/hypr/hyprpaper.conf
rofi=~/dotfiles/config/rofi/colors.rasi
hypr=~/dotfiles/config/hypr/colors.conf
waybar=~/dotfiles/config/waybar/colors.css
dunst=~/dotfiles/config/dunst/colors

rm $xres
xrdb -remove

echo "dwm.normfgcolor: $foreground" | tee -a $xres
echo "dwm.normbgcolor: $background" | tee -a $xres
echo "dwm.normbordercolor: $lbackground" | tee -a $xres
echo "dwm.selfgcolor: $lforeground" | tee -a $xres
echo "dwm.selbgcolor: $lbackground" | tee -a $xres
echo "dwm.selbordercolor: $lforeground" | tee -a $xres

echo "st.nblack: $black" | tee -a $xres
echo "st.nred: $red"| tee -a $xres
echo "st.ngreen: $green" | tee -a $xres
echo "st.nyellow: $yellow" | tee -a $xres
echo "st.nblue: $blue" | tee -a $xres
echo "st.nmagenta: $magenta" | tee -a $xres
echo "st.ncyan: $cyan" | tee -a $xres
echo "st.nwhite: $white" | tee -a $xres

echo "st.bblack: $lblack" | tee -a $xres
echo "st.bred: $lred" | tee -a $xres
echo "st.bgreen: $lgreen"  | tee -a $xres
echo "st.byellow: $lyellow"  | tee -a $xres
echo "st.bblue: $lblue"  | tee -a $xres
echo "st.bmagenta: $lmagenta"  | tee -a $xres
echo "st.bcyan: $lcyan"  | tee -a $xres
echo "st.bwhite: $lwhite"  | tee -a $xres

echo "st.background: $background" | tee -a $xres
echo "st.foreground: $foreground" | tee -a $xres
echo "st.cursorColor: $cursor" | tee -a $xres

echo "dmenu.background: $background" | tee -a $xres
echo "dmenu.foreground: $foreground" | tee -a $xres
echo "dmenu.selforeground: $lforeground" | tee -a $xres
echo "dmenu.selbackground: $lbackground" | tee -a $xres

echo "emacs*background: $background" | tee -a $xres
echo "emacs*foreground: $foreground" | tee -a $xres
echo "emacs*color0: $color0" | tee -a $xres
echo "emacs*color1: $color1" | tee -a $xres
echo "emacs*color2: $color2" | tee -a $xres
echo "emacs*color3: $color3" | tee -a $xres
echo "emacs*color4: $color4" | tee -a $xres
echo "emacs*color5: $color5" | tee -a $xres
echo "emacs*color6: $color6" | tee -a $xres
echo "emacs*color7: $color7" | tee -a $xres
echo "emacs*color8: $color8"  | tee -a $xres
echo "emacs*color9: $(getlightcolor.py $color1)"  | tee -a $xres
echo "emacs*color10: $(getlightcolor.py $color2)"  | tee -a $xres
echo "emacs*color11: $(getlightcolor.py $color3)"  | tee -a $xres
echo "emacs*color12: $(getlightcolor.py $color4)"  | tee -a $xres
echo "emacs*color13: $(getlightcolor.py $color5)"  | tee -a $xres
echo "emacs*color14: $(getlightcolor.py $color6)"  | tee -a $xres
echo "emacs*color15: $(getlightcolor.py $color7)"  | tee -a $xres

echo "Sxiv.background: $background" | tee -a $xres
echo "Sxiv.foreground: $foreground" | tee -a $xres

rm $alacritty
echo "colors:" | tee -a $alacritty
echo "  primary:" | tee -a $alacritty
echo "    background: '$background'" | tee -a $alacritty
echo "    foreground: '$foreground'" | tee -a $alacritty
echo "  normal:" | tee -a $alacritty
echo "    black: '$black'" | tee -a $alacritty
echo "    red: '$red'" | tee -a $alacritty
echo "    green: '$green'" | tee -a $alacritty
echo "    yellow: '$yellow'" | tee -a $alacritty
echo "    blue: '$blue'" | tee -a $alacritty
echo "    magenta: '$magenta'" | tee -a $alacritty
echo "    cyan: '$cyan'" | tee -a $alacritty
echo "    white: '$white'" | tee -a $alacritty
echo "  bright:" | tee -a $alacritty
echo "    black: '$lblack'" | tee -a $alacritty
echo "    red: '$lred'" | tee -a $alacritty
echo "    green: '$lgreen'" | tee -a $alacritty
echo "    yellow: '$lyellow'" | tee -a $alacritty
echo "    blue: '$lblue'" | tee -a $alacritty
echo "    magenta: '$lmagenta'" | tee -a $alacritty
echo "    cyan: '$lcyan'" | tee -a $alacritty
echo "    white: '$lwhite'" | tee -a $alacritty

rm $qute
cp $alacritty $qute

rm $hyprpaper
echo "preload = $1" | tee -a $hyprpaper
echo "wallpaper = ,$1" | tee -a $hyprpaper

rm $rofi
echo "* {" | tee -a $rofi
echo "    red: $(getrgba.py $red);" | tee -a $rofi
echo "    blue: $(getrgba.py $blue);" | tee -a $rofi
echo "    foreground: $(getrgba.py $foreground);" | tee -a $rofi
echo "    background: $(getrgba.py $background);" | tee -a $rofi
echo "    lightfg: $(getrgba.py $lbackground);" | tee -a $rofi
echo "    lightbg: $(getrgba.py $background);" | tee -a $rofi
echo "}" | tee -a $rofi

rm $hypr
echo "general {" | tee -a $hypr
echo "    col.active_border = rgba(${lforeground:1}ee)" | tee -a $hypr
echo "    col.inactive_border = rgba(${lbackground:1}ee)" | tee -a $hypr
echo "}" | tee -a $hypr
echo "decoration {" | tee -a $hypr
echo "    col.shadow = rgba(${background:1}ee)" | tee -a $hypr
echo "}" | tee -a $hypr

rm $waybar
echo "@define-color foreground $foreground;" | tee -a $waybar
echo "@define-color background $background;" | tee -a $waybar
echo "@define-color red $red;" | tee -a $waybar
echo "@define-color green $green;" | tee -a $waybar
echo "@define-color yellow $yellow;" | tee -a $waybar
echo "@define-color blue $blue;" | tee -a $waybar
echo "@define-color magenta $magenta;" | tee -a $waybar
echo "@define-color cyan $cyan;" | tee -a $waybar
echo "@define-color white $white;" | tee -a $waybar
echo "@define-color lblack $lblack;" | tee -a $waybar

rm $dunst
echo "[global]" | tee -a $dunst
echo "    frame_color = \"$lforeground\"" | tee -a $dunst
echo "[urgency_normal]" | tee -a $dunst
echo "    background = \"$background\"" | tee -a $dunst
echo "    foreground = \"$foreground\"" | tee -a $dunst

xrdb $xres

kill -9 $(top -bcn 1 | grep autostart.sh | sed 1q | awk '{print $1}')
xdotool key super+r
