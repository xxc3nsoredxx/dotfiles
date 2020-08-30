[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec urxvtd --quiet --opendisplay --fork &
exec dbus-launch --exit-with-session i3
