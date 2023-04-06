#!/bin/zsh

vmp() {
    col -b | \
    vim -MR \
    -c 'set ft=man nolist nonu nornu'
}
vimh() { vim -c "help $1" -c 'call feedkeys("\<c-w>o")' }

nnn() { test -z "$NNNLVL" && /usr/bin/nnn "$@" || exit }
ranger() { test -z "$RANGER_LEVEL" && /usr/bin/ranger "$@" || exit }

# googoo
o ()
{
	f="$(fhome f ${1:-$HOME} | fzf)"
	test "$1" && shift
	test -n "$f" && $EDITOR $@ "$f"
}
go ()
{
	d="$(fhome d ${1:-$HOME} | fzf)"
	test -d "$d" && cd "$d"
}
ogo ()
{
	d="$(fhome f ${1:-$HOME} | fzf | xargs dirname)"
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
	curl ${2:-"https://upfast.craftmenners.men/delete/$1"}
}
upfile () {
	curl -F "file=@\"$1\"" ${2:-"https://upfast.craftmenners.men"}
}

sgd () {
	for dir in ${1:-$HOME/src/*} 
	do 
		cd $dir 
		if [ "$(git status --short 2>/dev/null | grep -v "??" | head -1)" ]
		then
			# There are changes, and this is a git repo
			echo "$PWD \e[1;31m*changes\e[0m"
			git fetch > /dev/null 2>&1
		fi
		test "$(parse_git_remote)" && 
			echo "$PWD \e[0;32m*push/pull\e[0m"
		done
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
