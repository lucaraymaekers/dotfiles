#!/bin/zsh

die ()
{
	echo "$1" >&2
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
		vim "$match" && return
	else
		die "no match." && return 1
	fi
}

nnn() { test -z "$NNNLVL" && /usr/bin/nnn "$@" || exit }
ranger() { test -z "$RANGER_LEVEL" && /usr/bin/ranger "$@" || exit }

# googoo aliases
ff () { goo f "$1" | fzf }
fd () { goo d "$1" | fzf }
fdf () { goo f "$1" | fzf | xargs -I {} dirname "{}" }
o ()
{
	f="$(ff $1)"
	test "$1" && shift
	test -n "$f" && $EDITOR $@ "$f"
}
go ()
{
	d="$(fd $1)"
	test -d "$d" && cd "$d"
}
ogo ()
{
	d="$(fdf $1)"
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

calc () { echo "$@" | bc -l }

unique () {
	f="/tmp/$(uuidgen)"
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

fzh () {
    choice="$(tac $HOME/.config/zsh/histfile | fzf)"
    test -z "${choice}" && return
    echo "${choice}" >> "${HOME}/.config/zsh/histfile"
    eval "${choice}"
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
	curl ${2:-"https://up.kallipso.be/delete/$1"}
}
upfile () {
	curl -F "file=@\"$1\"" ${2:-"https://up.kallipso.be"}
}

sgd () {
	d="$PWD"
	for dir in ${1:-$HOME/src/*} 
	do 
		cd $dir
		git fetch > /dev/null 2>&1
		if [ "$(git status --short 2>/dev/null | grep -v "??" | head -1)" ]
		then
			# There are changes, and this is a git repo
			echo "$PWD \e[1;31m*changes\e[0m"
		fi
		test "$(parse_git_remote)" && 
			echo "$PWD \e[0;32m*push/pull\e[0m"
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
