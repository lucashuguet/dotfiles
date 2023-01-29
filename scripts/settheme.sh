#!/usr/bin/env sh
wal -qntes -i "$1"
source ~/.cache/wal/colors.sh

feh --bg-fill $wallpaper

rm ~/.Xresources
xrdb -remove

echo "dwm.normfgcolor: $foreground" | tee -a ~/.Xresources
echo "dwm.normbgcolor: $background" | tee -a ~/.Xresources
echo "dwm.normbordercolor: $color8" | tee -a ~/.Xresources
echo "dwm.selfgcolor: $color7" | tee -a ~/.Xresources
echo "dwm.selbgcolor: $color10" | tee -a ~/.Xresources
echo "dwm.selbordercolor: $color7" | tee -a ~/.Xresources

echo "st.nblack: $color0" | tee -a ~/.Xresources
echo "st.nred: $color1"| tee -a ~/.Xresources
echo "st.ngreen: $color2" | tee -a ~/.Xresources
echo "st.nyellow: $color3" | tee -a ~/.Xresources
echo "st.nblue: $color4" | tee -a ~/.Xresources
echo "st.nmagenta: $color5" | tee -a ~/.Xresources
echo "st.ncyan: $color6" | tee -a ~/.Xresources
echo "st.nwhite: $color7" | tee -a ~/.Xresources

echo "st.bblack: $color8" | tee -a ~/.Xresources
echo "st.bred: $(getlightcolor.py $color1)" | tee -a ~/.Xresources
echo "st.bgreen: $(getlightcolor.py $color2)"  | tee -a ~/.Xresources
echo "st.byellow: $(getlightcolor.py $color3)"  | tee -a ~/.Xresources
echo "st.bblue: $(getlightcolor.py $color4)"  | tee -a ~/.Xresources
echo "st.bmagenta: $(getlightcolor.py $color5)"  | tee -a ~/.Xresources
echo "st.bcyan: $(getlightcolor.py $color6)"  | tee -a ~/.Xresources
echo "st.bwhite: $(getlightcolor.py $color7)"  | tee -a ~/.Xresources

echo "st.background: $background" | tee -a ~/.Xresources
echo "st.foreground: $foreground" | tee -a ~/.Xresources
echo "st.cursorColor: $cursor" | tee -a ~/.Xresources

echo "dmenu.background: $background" | tee -a ~/.Xresources
echo "dmenu.foreground: $foreground" | tee -a ~/.Xresources
echo "dmenu.selforeground: $color7" | tee -a ~/.Xresources
echo "dmenu.selbackground: $color10" | tee -a ~/.Xresources

echo "emacs*background: $background" | tee -a ~/.Xresources
echo "emacs*foreground: $foreground" | tee -a ~/.Xresources
echo "emacs*color0: $color0" | tee -a ~/.Xresources
echo "emacs*color1: $color1" | tee -a ~/.Xresources
echo "emacs*color2: $color2" | tee -a ~/.Xresources
echo "emacs*color3: $color3" | tee -a ~/.Xresources
echo "emacs*color4: $color4" | tee -a ~/.Xresources
echo "emacs*color5: $color5" | tee -a ~/.Xresources
echo "emacs*color6: $color6" | tee -a ~/.Xresources
echo "emacs*color7: $color7" | tee -a ~/.Xresources
echo "emacs*color8: $color8"  | tee -a ~/.Xresources
echo "emacs*color9: $(getlightcolor.py $color1)"  | tee -a ~/.Xresources
echo "emacs*color10: $(getlightcolor.py $color2)"  | tee -a ~/.Xresources
echo "emacs*color11: $(getlightcolor.py $color3)"  | tee -a ~/.Xresources
echo "emacs*color12: $(getlightcolor.py $color4)"  | tee -a ~/.Xresources
echo "emacs*color13: $(getlightcolor.py $color5)"  | tee -a ~/.Xresources
echo "emacs*color14: $(getlightcolor.py $color6)"  | tee -a ~/.Xresources
echo "emacs*color15: $(getlightcolor.py $color7)"  | tee -a ~/.Xresources

echo "Sxiv.background: $background" | tee -a ~/.Xresources
echo "Sxiv.foreground: $foreground" | tee -a ~/.Xresources

echo "qutebrowser.background: $background" | tee -a ~/.Xresources
echo "qutebrowser.foreground: $foreground" | tee -a ~/.Xresources
echo "qutebrowser.color8: $color8" | tee -a ~/.Xresources
echo "qutebrowser.color14: $color14" | tee -a ~/.Xresources

xrdb ~/.Xresources

kill -9 $(top -bcn 1 | grep autostart.sh | sed 1q | awk '{print $1}')
xdotool key super+r

systemctl restart --user emacs.service
