#!/bin/sh

if ! stow --version > /dev/null 2>&1
then
	echo "E: stow not installed or not found" 1>&2
	exit 1
fi
if [ -n "$MACH" ]
then
	echo "I: stowing for $MACH"
else
	echo "E: MACH not set"
	exit 1
fi

case "$MACH" in
	"desktop")
		mkdir -p "$HOME/bin"
		stow -d bin/ -t "$HOME/bin" -R common dmscripts extra
		mkdir -p "$HOME/.config"
		stow -d config/ -t "$HOME/.config" -R essentials common extra theme X
		stow -d config/ -t "$HOME/" -R zshrc
		;;
	"server")
		mkdir -p "$HOME/bin"
		stow -d bin/ -t "$HOME/bin" -R common
		mkdir -p "$HOME/.config"
		stow -d config/ -t "$HOME/.config" -R essentials common
		stow -d config/ -t "$HOME/" -R zshrc
		;;
	"laptop")
		mkdir -p "$HOME/bin"
		stow -d bin/ -t "$HOME/bin" -R common dmscripts extra
		mkdir -p "$HOME/.config"
		stow -d config/ -t "$HOME/.config" -R essentials common extra theme hyprland X
		stow -d config/ -t "$HOME/" -R zshrc
		;;
	*)
		break
esac
