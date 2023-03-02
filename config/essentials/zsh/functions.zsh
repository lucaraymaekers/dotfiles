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
	f="$(fzffile $1)"
	test "$#" -gt 0 && shift
	test -n "$f" && $EDITOR $@ "$f"
}
go ()
{
	d="$(fzfdir $1)"
	test -d "$d" && cd "$d"
}
ogo ()
{
	d="$(fzfdirfile $1)"
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

clip () { echo -n "$@" | xclip -selection clipboard -rmlastnl }

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
