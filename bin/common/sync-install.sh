#!/bin/sh

die ()
{
	echo "$@" >&2
}

read_char ()
{
	old_stty_cfg=$(stty -g)
	stty raw -echo 
	dd ibs=1 count=1 2> /dev/null
	stty $old_stty_cfg
}

confirm ()
{
	printf "$1 "
	read_char | grep "[yY]"
}

usage()
{
	>&2 printf 'Usage: %s <remote> <destination>\n' "${0##*/}"
}

[ $# -lt 2 ] && usage && exit 1
REMOTE="$1"
DEST="$2"
SCRIPT="${3:-sync.sh}"

if ! ssh $REMOTE test -w $DEST 2> /dev/null
then
	die "Not a valid remote or destination."
	exit 1
fi

die "─────────────────────────────────────────────────────────────"
cat <<EOF | tee "$SCRIPT" >&2
#!/bin/sh

THISDIR="\$(dirname "\$(readlink -f "\$0")")"
inotifywait -m -e create,modify,delete --format "%f" "\$THISDIR" | 
while read FILE
do
	rsync -aP "\$THISDIR/" "$REMOTE:$DEST"
	sleep 1m
done
EOF
die "─────────────────────────────────────────────────────────────"
die "located at $(readlink -f "$SCRIPT")"

if confirm "good?"
then
	chmod +x "$SCRIPT"
else
	rm -f "$SCRIPT"
fi
