[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec urxvtd --quiet --opendisplay --fork &
exec i3
