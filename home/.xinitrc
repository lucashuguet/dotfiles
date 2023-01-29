if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

bash ~/dotfiles/scripts/audio.sh

exec feh --bg-fill ~/dotfiles/wallpaper/gobacktothefuture.png &
exec nm-applet &
exec blueman-applet &
exec flameshot &
exec pasystray &
exec picom --config ~/.config/picom/picom-blur.conf --experimental-backends &
exec dunst &
exec clipster -d &
exec emacs --daemon &

exec qtile start
