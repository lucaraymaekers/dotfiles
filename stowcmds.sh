#!/bin/sh

trap "echo -ne '\nbye'; exit 1" EXIT

if ! stow --version > /dev/null 2>&1
then
	echo "E: stow not installed or not found" 1>&2
	exit 1
fi
if [ -n "${MACH:=$1}" ]
then
	echo "I: stowing for $MACH"
else
	echo "E: MACH not set" 1>&2
	echo "Enter valid value for 'MACH'"
	echo "d(esktop) | s(erver) | l(aptop)"
	echo -n ">"
	read MACH
fi

case "$MACH" in
	"desktop" | "d" | "laptop" | "l")
		mkdir -p "$HOME/bin"
		stow -d bin/ -t "$HOME/bin" -R common guiscripts extra
		mkdir -p "$HOME/.config"
		stow -d config/ -t "$HOME/.config" -R essentials common extra X theme xdg hyprland
		stow -d config/ -t "$HOME/" -R home
		;;
	"server" | "s")
		mkdir -p "$HOME/bin"
		stow -d bin/ -t "$HOME/bin" -R common serverscripts
		mkdir -p "$HOME/.config"
		stow -d config/ -t "$HOME/.config" -R essentials common
		stow -d config/ -t "$HOME/" -R home
		;;
	*)
		echo "E: invalid value for 'MACH'" 1>&2
		break
esac
