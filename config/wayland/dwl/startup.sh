#!/bin/sh

for prog in dwl-bar dwlblocks gammastep mako
do
	pkill "$prog"
	$prog &
done

swaybg -i ~/pics/wallpaper &
wl-paste --watch cliphist store &
swayidle 300 locker &
keyadd id_rsa &

pkill -f "tail -f $HOME/.config/wob/pipe"
WOBCONFIG="$HOME"/.config/wob
if [ ! -p "$WOBCONFIG"/pipe ]
then
	mkdir -p "$WOBCONFIG"
	mkfifo "$WOBCONFIG"/pipe
fi
(tail -f "$WOBCONFIG"/pipe | wob) &

$TERMINAL -e tmux a || $TERMINAL tmux &
