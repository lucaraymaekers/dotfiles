#!/bin/zsh

die ()
{
	echo "$@" >&2
}

awnk() {
	awk "{print \$$1}"
}

vmp() {
    col -b | \
    vim -MR \
    -c 'set ft=man nolist nonu nornu'
}
vimh() {
	vim -c "help $1" -c 'call feedkeys("\<c-w>o")'
}
nvf() {
	local cache="$HOME/.cache/nvf"
	local match="$(grep -m1 "$1$" "$cache" 2> /dev/null)"
	if test ! -f "$match"
	then
		die "resetting cache..."
		match="$(goo | tee "$cache" | grep -m 1 "$1$" 2> /dev/null)"
		# # Alternative:
		# match="$(goo | grep -m 1 "$1" 2> /dev/null | tee -a | "$cache")"
	fi
	if test -f "$match"
	then
		$EDITOR "$match" && return
	else
		die "no match." && return 1
	fi
}

nnn() { test -z "$NNNLVL" && /usr/bin/nnn "$@" || exit }
ranger() { test -z "$RANGER_LEVEL" && /usr/bin/ranger "$@" || exit }

# googoo aliases
_googoo_fzf_opt ()
{
	if [ "$1" ]
	then
		[ -d "$1" ] && dest="$1" || opt="-q $1"
	fi
}
o ()
{
	_googoo_fzf_opt "$1"
	f="$(goo f "dest" | fzf $opt)"
	test "$1" && shift
	test -f "$f" && $EDITOR $@ "$f"
}
go ()
{
	_googoo_fzf_opt "$1"
	d="$(goo d "$dest" | fzf $opt)"
	test -d "$d" && cd "$d"
}
ogo ()
{
	_googoo_fzf_opt "$1"
	d="$(dirname "$(goo f "$dest")" | fzf $opt)"
	test -d "$d" && cd "$d"
}

ipc () 
{
   if [[ "$(ip link show eno1 | awk -F, 'NR=1 {print $3}')" == "UP" ]]
   then
        doas ip link set eno1 down
    else
        doas ip link set eno1 up 
   fi
}

calc () { echo "$@" | bc -l | numfmt --grouping; }

psgrep ()
{
	[ $# -eq 0 ] && return 1
	pgrep "$@" | xargs ps
}

unique () {
	local f
	f="$(mktemp)"
	awk '!x[$0]++' "$1" > "$f"
	mv "$f" "$1"
}

clip () { 
	if [ "$WAYLAND_DISPLAY" ]
	then
		echo -n "$@" | wl-copy
	else
		echo -n "$@" | xclip -selection clipboard -rmlastnl
	fi
}

unzipp () {
    file=$1
    shift
    unzip $file $@ || exit 1
    rm $file
}

# fix long waiting time
__git_files () { 
    _wanted files expl 'local files' _files     
}

esc () {
	$EDITOR "$(which $1)"
}

delfile () {
	curl "${2:-https://upfast.cronyakatsuki.xyz/delete/$1}"
}
upfile () {
	curl -F "file=@\"$1\"" ${2:-https://upfast.cronyakatsuki.xyz}
}

sgd () {
	d="$PWD"
	find $HOME/src -maxdepth 1 -mindepth 1 -type d |
		while read -r dir
	do
		cd "$dir"
		git status > /dev/null 2>&1 || continue
		git fetch > /dev/null 2>&1
		printf "$PWD"
		test "$(git status --short 2>/dev/null | grep -v "??" | head -1)" &&
			printf " \e[1;31m*changes\e[0m" | sed "s#$HOME#~#" >&2
		test "$(parse_git_remote)" && 
			printf " \e[0;32m*push/pull\e[0m" | sed "s#$HOME#~#" >&2
		printf "\n"
	done
	cd "$d"
	unset d
}

# Git functions
# Returns current branch
function git_current_branch()
{
	command git rev-parse --git-dir &>/dev/null || return
	git branch --show-current
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

# gpg backup
gpg_backup ()
{
	gpg --export-secret-keys --armor > private.asc
	gpg --export --armor > public.asc
	gpg --export-ownertrust --armor > trust.asc
	tar czf gpg_backup.tar.gz {public,private,trust}.asc
	shred -uz {public,private,trust}.asc
}

gpg_import ()
{
	tar xf $1
	shred -uz $1
	gpg --import public.asc
	gpg --import-ownertrust trust.asc
	gpg --import private.asc
	shred -uz {public,private,trust}.asc
}

ngenable ()
{
	ln -sf /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
}

vbsr ()
{
	vboxmanage snapshot "$1" restore "$2" &&
		vboxmanage startvm "$1" ||
		vboxmanage controlvm "$1" poweroff
}
vbsrr ()
{
	vbsr "$1" "$2"
	sleep 3
	vbsr "$1" "$2"
}
vbst ()
{
	vboxmanage snapshot "$1" take "$2"
}

pacsize ()
{
	if test -n "$1"; then
		packages="$@"
	elif test ! -t 0; then
		packages="$(cat)"
	else
		echo "No data provided..."
		return 1
	fi
	echo $packages |
		expac '%m %n' - |
		numfmt --to=iec-i --suffix=B --format="%.2f"
}
pkbs ()
{
	pkgfile -b "$1" | tee /dev/stderr | doas pacman -S -
}

mime-default ()
{
	die "Setting '$1' as default for its mimetypes"
	grep "MimeType=" /usr/share/applications/"$1" |
		cut -d '=' -f 2- |
		tr ';' '\n' |
		xargs -I {} xdg-mime default "$1" "{}"
	die "Done."
}

addedkeys () {
	find ~/.ssh -iname "*.pub" | while read key
	do 
		local fingerprint="$(ssh-keygen -lf "$key" 2>/dev/null)" 
		if ssh-add -l | grep -q "$fingerprint"
		then
		echo "$key"
		fi
	done | sed "s,$HOME/.ssh/,,"
}

fpass () {
	find $HOME/.password-store -type f -not -path ".git" |
		grep "\.gpg$" |
		sed "s,$HOME/.password-store/,,;s,\.gpg$,," |
		fzf |
		xargs pass show -c
}

oclip ()
{
	printf "\033]52;c;$(echo -n "$@" | base64)\a"
}

sms ()
{
	ssh phone sendmsg "$1" "'$2'"
}

trcp ()
{
	scp "$1" db:/media/basilisk/downloads/transmission/torrents/
}

muttmail ()
{
	die -n "email set: "
	ls $HOME/.config/mutt/configs |
		fzf |
		tee /dev/stderr |
		xargs -I {} ln -sf "$HOME/.config/mutt/configs/{}" $HOME/.config/mutt/muttrc
	die -n 'Press [Enter to login]'
	read && mutt
}

resize ()
{
	test $# -lt 2 &&
		printf "usage: %s <format> <file> [out]\n" "$0" >&2 &&
		return 1
	convert -resize $1^ -gravity center -crop $1+0+0 -- "$2" "${3:-$1}"
}
