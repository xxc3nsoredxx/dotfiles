[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
urxvtd --quiet --opendisplay --fork &
exec i3
