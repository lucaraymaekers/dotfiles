for file in /{etc,usr/lib}/os-release
do [ -f "$file" ] && . "$file" && break
done
case "${ID:=unknown}" in
	debian|ubuntu) PLUGPATH=/usr/share/ ;;
	unknown) PLUGPATH=$ZDOTDIR/plugins ;;
	*) PLUGPATH=/usr/share/zsh/plugins ;;
esac
. $PLUGPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. $PLUGPATH/zsh-autosuggestions/zsh-autosuggestions.zsh
