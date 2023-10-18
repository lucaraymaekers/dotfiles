#!/bin/sh
swaybg -i ~/pics/wallpaper &
dwl-bar &
gammastep &
wl-paste --watch cliphist store &
keyadd id_rsa &
swayidle 300 locker &
mako &
$TERMINAL -e tmux a || $TERMINAL tmux &
