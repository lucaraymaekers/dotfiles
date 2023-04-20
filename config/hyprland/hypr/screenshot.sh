case $1 in
	"-m")
		actwin="$(hyprctl activewindow -j | jq -r '.monitor')"
		actmon="$(hyprctl monitors -j |
			jq -r ".[] | select(.id == $actwin)" |
			jq -r '.name')" 
		grim -o "$actmon" $HOME/pics/screenshots/"$(date +%y%m%d_%H_%M_%S.png)"
		;;
	"-f")
		grim $HOME/pics/screenshots/"$(date +%y%m%d_%H_%M_%S.png)"
		;;
	"-s")
		grim -g "$(slurp)" $HOME/pics/screenshots/"$(date +%y%m%d_%H_%M_%S.png)"
		;;
	"-sc")
		grim -g "$(slurp)" - | wl-copy
		;;
	*)
		exit
		;;
esac
