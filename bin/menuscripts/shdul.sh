#!/bin/sh

tmp="$(mktemp)"

red="$(printf '\033[35m')"
blue="$(printf '\033[34m')"
reset="$(printf '\033[0m')"
underline="$(printf '\033[4m')"
bold="$(printf '\033[1m')"

THISDIR="$(dirname "$(readlink -f "$0")")"
# schedule file
SCHEDULE="$THISDIR/schedule"
# blocks directory
BLOCKS="$THISDIR/blocks"

die () { >&2 printf "%s" "$@"; exit 1; }
log () { >&2 printf '%s' "$@"; }
logn () { >&2 printf '%s\n' "$@"; }

cleanup () { rm -f "$tmp"; }

trap cleanup EXIT

read_char ()
{
	old_stty_cfg=$(stty -g)
	stty raw -echo 
	dd ibs=1 count=1 2> /dev/null
	stty "$old_stty_cfg"
}

edit_schedule ()
{
	while true
	do
		char="$(read_char)"
		case "$char" in
			q) exit ;;
			a) add_block ;;
			# new or from save
			d) delete_block ;;
			'') ;;
			*) printf "%s" "$char"
		esac
	done

}

# adds NOW to the schedule and gets its line number
# $1: schedule file
get_now ()
{
	fake="$(date +%R)\tZZZZZZZZZZZZZZZZ - NOW"
	sed "\$a $fake" "$1" |
		sort -g |
		awk "/^$fake/ {print NR}"
}

# prints schedule in a nice format
# $1: schedule file
# $2: blocks dir
print_schedule ()
{
	now="$(get_now "$1")"

	clear

	i=1
	while read -r line
	do
		[ "$i" -lt "$((now-1))" ] && i=$((i+1)) && continue
		i=$((i+1))

		# Colors
		if [ "$i" -lt "$now" ]
		then
			printf "%s" "${reset}${red}"
		elif [ "$i" -eq "$now" ]
		then
			printf "%s" "${reset}${bold}"
		else
			printf "%s" "${reset}${blue}"
		fi

		block_file="$2/$(printf "%s" "$line" | cut -f2)"
		block_time="$(printf "%s" "$line" | cut -f1)"

		# markup
		printf "%s\n" "$block_time"
		sed 's/.*/│&/' "$block_file"
		# printf '\n'
		
	done < "$1"

	printf '%s' "${reset}"
}

# $1: schedule file
# $2: blocks dir
view_schedule()
{
	trap "break" INT

	prev_now="$(get_now "$1")"
	print_schedule "$1" "$2"
	while true
	do
		now="$(get_now "$1")"

		# Refresh when new block
		if [ "$prev_now" -ne "$now" ]
		then
			print_schedule "$1" "$2"
			prev_now="$now"
			notify-send -u critical -t 5000 "shdul" "$(awk "NR==$((now-1)) {print \$2}" "$1")"

			# Align with clock
			sleep "$((60-$(date +%-S)))s"
		else
			sleep 1m
		fi
	done

	clear
}

main ()
{
	echo $$ > "$THISDIR/.scheduler.pid"

	view_schedule "$SCHEDULE" "$BLOCKS"
	while true
	do
		printf ':'
		char="$(read_char)"
		case "$char" in
			h) cat <<-EOF

				 h	help
				 v	view schedule
				 s	edit schedule mode
				 q	exit

				EOF
				;;
			l) clear ;;
			v) view_schedule "$SCHEDULE" "$BLOCKS" ;;
			s) edit_schedule ;;
			q) exit ;;
			'') ;;
			*) printf "%s" "$char"
		esac
	done
}

main
