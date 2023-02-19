#!/usr/bin/env bash

case "${MACH:=desktop}" in
	'desktop')
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
	*)
		break
esac
