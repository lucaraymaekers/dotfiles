#!/bin/sh

VERSION="0.3"

batch=0
rename=0

help ()
{
	cat <<-EOF >&2
	Usage: treetag.sh [options]
	Options:
	-b              Enable batch mode
	-d <directory>  Specify the music directory
	-h              Show this help message and exit
	-r              also rename file
	-v              Print version information and exit
	EOF
}

log () { >&2 printf '%s\n' "$@"; }
die () { log "$@"; exit 1; }
require () { command -v "$1" > /dev/null || die "E: This script needs '$1' to be installed."; }
ls_dirs() { find . -mindepth 1 -maxdepth 1 -type d -printf "%f\n"; }

### Tag files in the current directory
# $1: artist name
# $2: album name
treetag ()
{
	[ -z "$1" ] || [ -z "$2" ] && return 1
	artist="$1"
	album="$2"

	>&2 printf "artist: %s\n" "$artist"
	>&2 printf "album: %s\n" "$album"
	find . -maxdepth 1 -type f -printf '%f\n' | sort -g |
		while read -r file
		do
			>&2 printf "file: %s\n" "$file"
			! soxi "$file" > /dev/null 2>&1 && continue

			# Remove number prefix and extension
			name="$(printf '%s' "${file%.*}" | sed 's/^[0-9]*\s*[. -]\s*//')"
			i=$((i+1))

			log "I: [$artist] ($album) #$i $name"

			id3v2 \
				-a "$artist" \
				-A "$album" \
				-t "$name" \
				-T "$i" \
				-- "$file"
			printf '%s\n' "$i" > .count

			[ $rename -eq 1 ] && mv -- "$file" "$i. $name.${file##*.}"

		done
		if [ -f .count ]
		then
			log "I: $(cat .count) file(s) tagged."
			rm .count
		else
			log "I: No files tagged."
		fi
}

batch_tag ()
{
	artist="${PWD##*/}" # basename of current dir
	ls_dirs |
		while read -r album
		do (cd "$album" && treetag "$artist" "$album")
		done
}

# Tag interactively with fzf
interactive ()
{
	require "fzf"

	artist="$(ls_dirs | fzf)"
	[ "$artist" ] && cd "$artist" || exit 1

	choice="$artist"
	while true
	do
		choice="$(ls_dirs | fzf --prompt "$choice:")"
		if [ "$choice" ]
		then 
			album="$choice"
			cd "$album" || exit 1

			printf 'stop? '
			head -n 1 | grep -q "[yY]" && break
		else 
			break
		fi
	done

	treetag "$artist" "$album"
}

while getopts ":d:bhrv" opt
do
	case $opt in
		b) batch=1 ;;
		d) musdir="$OPTARG" ;;
		h) help; exit ;;
		r) rename=1 ;;
		v) log "treetag.sh $VERSION"; exit ;;
		:) die "E: Option -$OPTARG requires an argument" ;;
		?) die "E: Invalid option: -$OPTARG" ;;
	esac
done

require "id3v2"
require "sox"

cd "${musdir:=.}" || exit 1

if [ $batch -eq 1 ] 
then
	batch_tag
else
	interactive
fi
