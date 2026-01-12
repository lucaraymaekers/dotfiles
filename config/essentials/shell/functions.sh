#!/bin/sh

log() { >&2 printf '%s' "$@"; }
logn() { >&2 printf '%s\n' "$@"; }

vmp() {
    col -b | \
    vim -MR \
    -c 'set ft=man nolist nonu nornu'
}
nvf() {
	cache="$HOME/.cache/nvf"
	match="$(grep -m1 "$1$" "$cache" 2> /dev/null)"
	if test ! -f "$match"
	then
		logn "resetting cache..."
		match="$(goo f "$HOME" | tee "$cache" | grep -m 1 "$1$" 2> /dev/null)"
		# # Alternative:
		# match="$(goo | grep -m 1 "$1" 2> /dev/null | tee -a | "$cache")"
	fi
	if test -f "$match"
	then
		$EDITOR "$match" && return
	else
		logn "no match." && return 1
	fi
}

nnn() { test -z "$NNNLVL" && /usr/bin/nnn "$@" || exit; }
ranger() { test -z "$RANGER_LEVEL" && /usr/bin/ranger "$@" || exit; }

# googoo aliases
_googoo_fzf_opt()
{
	unset dest opt
	if [ "$1" ]
	then
		[ -d "$1" ] && dest="$1" || opt="-q $1"
	fi
}
o()
{
	_googoo_fzf_opt "$1"
	f="$(goo f "$dest" | fzf $opt)"
	test "$1" && shift
	test -f "$f" && $EDITOR $@ "$f"
}
og()
{
	_googoo_fzf_opt "$1"
	cd "$(goo d "$dest" | fzf $opt)"
}
oog()
{
	_googoo_fzf_opt "$1"
	cd "$(dirname "$(goo f "$dest" | fzf $opt)")"
}

# Onelineres
awnk() { awk "{print \$$1}"; }
vimh() { vi -c "help $1" -c 'call feedkeys("\<c-w>o")'; }
dgo() { cd "$(goo d ~ | fzf --filter "$@" | head -n 1)"; }
open() { $EDITOR "$(goo f ~ | fzf --filter "$@" | head -n 1)"; }
pkbs() { doas pacman -Sy "$(pkgfile -b "$1" | tee /dev/stderr)"; }
oclip() { printf "\033]52;c;$(printf '%s' "$@" | base64)\a"; }
oclipp() { printf "]52;c$(cat | base64)"; }
sms() { ssh -t phone sendmsg "$1" "'$2'"; }
trcp() { scp "$1" db:/media/basilisk/downloads/transmission/torrents/; }
rln() { ln -s "$(readlink -f "$1")" "$2"; }
getgit() { git clone git@db:"$1"; }
esc() { eval "$EDITOR '$(which $1)'"; }
ssh_keyadd() { ssh-keygen -f "$HOME"/.ssh/"$1" -P "$(pass generate -f keys/"$HOST"/ssh/"$1" | tail -n 1)" -t ed25519; }
delfile() { curl -s -X DELETE -L "${2:-https://upfast.cronyakatsuki.xyz/files/$1}"; }
upfile() { curl -s -L -F "file=@\"$1\"" "${2:-https://upfast.cronyakatsuki.xyz}"; }
upfile-dufs() { curl -T "$1" http://192.168.178.79:5000/"$1"; }
delfile-dufs() { curl -X DELETE http://192.168.178.79:5000/"$1"; }
getfile-dufs() { curl http://192.168.178.79:5000/"$1"; }
lsfile-dufs() { curl http://192.168.178.79:5000?simple; }
to_webm() { ffmpeg -y -i "$1" -vcodec libvpx -cpu-used -12 -deadline realtime "${1%.*}".webm; }
ngenable() { ln -sf /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/; }
remove_audio() { ffmpeg -i "$1" -cpu-used -$(nproc) -deadline realtime -c copy -an "${2:-out.mp4}"; }
nasg() { smbclient //192.168.178.24/Public/ -D ENFANTS/Luca/tmp -N -c "get $1"; }
vidlen() { date -u -d @"$(ffprobe -show_entries format=duration -v quiet -of csv="p=0" -i "$1")" +'%T'; }
pcp() { readlink -f "$1" | tr -d '\n' | clipp; }

ipc() 
{
   if [ "$(ip link show eno1 | awk -F, 'NR=1 {print $3}')" = "UP" ]
   then
        doas ip link set eno1 down
    else
        doas ip link set eno1 up 
   fi
}

psgrep()
{
	[ $# -eq 0 ] && return 1
	pgrep "$@" | xargs ps
}

unique() {
	f="$(mktemp)"
	awk '!x[$0]++' "$1" > "$f"
	mv "$f" "$1"
}

clip() { 
	if [ "$WAYLAND_DISPLAY" ]
	then
		echo -n "$@" | wl-copy
	else
		echo -n "$@" | xsel -b
	fi
}

unzipp() {
	unzip -- "$(readlink -f -- "$1")" || return 1
    rm -- "$1"
}

# fix long waiting time
__git_files() { _wanted files expl 'local files' _files; }

# Returns current branch
git_current_branch()
{
	command git rev-parse --git-dir > /dev/null 2>&1 || return
	git branch --show-current
}

# Check if main exists and use instead of master
git_main_branch()
{
  command git rev-parse --git-dir > /dev/null 2>&1 || return
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}
  do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir > /dev/null 2>&1 || return
  for branch in dev devel development
  do
    if command git show-ref -q --verify refs/heads/$branch
    then
      echo $branch
      return
    fi
  done
  echo develop
}

# gpg backup
# $1: key
gpg_backup()
{
    key="$(gpg --list-keys --with-colons | awk -F: '/^uid/ {print $10}' |sort|uniq | fzf)"
    [ "$key" ] || exit 1
    gpg --armor --export-secret-keys "$key" > private.asc
    gpg --armor --export "$key" > public.asc
    gpg --armor --export-ownertrust > trust.asc
    zip gpg_backup.zip public.asc private.asc trust.asc
    shred -uz public.asc private.asc trust.asc
}

# $1: backup zip
gpg_import()
{
	unzip $1
	shred -uz $1
	gpg --import public.asc
	gpg --import-ownertrust trust.asc
	gpg --import private.asc
	shred -uz public.asc private.asc trust.asc
}

vbsr()
{
	vboxmanage snapshot "$1" restore "$2" &&
		vboxmanage startvm "$1" ||
		vboxmanage controlvm "$1" poweroff
}
vbsrr()
{
	vbsr "$1" "$2"
	sleep 3
	vbsr "$1" "$2"
}
vbst()
{
	vboxmanage snapshot "$1" take "$2"
}

pacsize()
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

mime-default ()
{
	mime=
    [ "${mime:=${1%.desktop}}" ] ||
        mime="$(find /usr/share/applications/ -iname '*.desktop' -printf '%f\n' |
            sed 's/\.desktop$//' |
            fzf)"

	logn "Setting '$mime' as default for its mimetypes"
    [ "$mime" ] || exit 1
	grep "MimeType=" /usr/share/applications/"$mime".desktop |
		cut -d '=' -f 2- | tr ';' '\0' |
		xargs -0I{} xdg-mime default "$mime".desktop "{}"
	logn "Done."
}

addedkeys() {
	find ~/.ssh -iname "*.pub" | while read key
	do 
		fingerprint="$(ssh-keygen -lf "$key" 2>/dev/null)" 
		if ssh-add -l | grep -q "$fingerprint"
		then
		echo "$key"
		fi
	done | sed "s,$HOME/.ssh/,,"
}

fpass() {
	find $HOME/.password-store -type f -not -path ".git" |
		grep "\.gpg$" |
		sed "s,$HOME/.password-store/,,;s,\.gpg$,," |
		fzf |
		xargs pass show -c
}

muttmail()
{
	config="$HOME/.config/mutt"
	mail="$(find "$config"/configs -type f -printf '%f\n' | fzf)"
	[ "$mail" ] || return 1
    printf 'source %s\n' "$config"/configs/"$mail" > "$config"/muttrc
	mutt
}

resize()
{
	test $# -lt 2 &&
		printf "usage: %s <format> <file> [out]\n" "$0" >&2 &&
		return 1
	convert -resize $1^ -gravity center -crop $1+0+0 -- "$2" "${3:-$1}"
}

edit_in_dir() { 
	file="$1/$(goo f "$1" | sed "s@^$1@@" | fzf)"
	[ -f "$file" ] || return 1
	$EDITOR "$file"
}

# Download a file from google drive
# link like this: https://drive.usercontent.google.com/download?id=1TiJDEftTtF1KTMBI950Bj487ndYqkwpQ&export=download
gdown () {
        agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/12$(head /dev/urandom | tr -dc '0-1' | cut -c1).0.0.0 Safari/537.36"
        uuid=$(curl -sL "$1" -A "$agent" | sed -nE 's|.*(uuid=[^"]*)".*|\1|p')
        aria2c -x16 -s16 "$1&confirm=t&$uuid" -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" --summary-interval=0 -d "${2:-.}"
}

# toggle wireguard vpn on $1 -> interface
wgt() { 
	d="${1:-wg0}"
	ip -br a | awk '{print $1}' | grep "$d" > /dev/null &&
        doas wg-quick down "$d" ||
        doas wg-quick up "$d"
}



fchange()
{
    [ "$1" ] || return 1
    inotifywait -m -e create,modify,delete --format "%f" "${2:-.}"  |
        while read -r EVENT
        do
            eval "$1"
        done
}

unhappy.exe() {
    [ "$1" ] &&
        smiles=("[: " ".-." " :]" "._.") ||
        smiles=("]: " ".-." " :[" "._.")

	while true
	do
		for s in $smiles
		do
			printf '\r%s' "$s"
			sleep 1
		done
	done
}

ssh_port()
{
    ssh -f -N -L 0.0.0.0:"$3":localhost:"$1" "$2"
    >&2 printf "Forwarded port '%s' on '%s' to '%s'.\n" "$1" "$2" "$3"
}
ffconcat () {
	tmp=$(mktemp -p . ffconcat.XXXXX) 
	sed 's/.*/file &/' > "$tmp"
	ffmpeg -y -f concat -safe 0 -i $tmp -c copy "$1"
	rm $tmp
}
nvim_bindings() {  
    tmp="$(mktemp)"
    nvim +":set nomore | :redir! > $tmp | :map | :redir END | :q"  > /dev/null
    eval "nvim $(fzf < "$tmp" | awk '{print $NF}' | cut -f1 -d'>' | sed 's/:/ +/')"
    rm "$tmp"
}

prj() { cd "$(prj_select)"; }

prje() {
    prj || return 1
    f="$(git ls-files | fzf)"
    [ "$f" ] || return 1
    if [ -f "$f" ] 
    then
        "$EDITOR" "$f"
    else
        cd -
    fi
}
nprj() {
    if [ "$1" ] 
    then
        p="$1"
    else
        printf '>'
        p="$(head -n1)"
        [ "$p" ] || exit 1
    fi

    mkdir -p "$HOME/proj/$p"
    cd "$HOME/proj/$p"
}

edit_git_file () {
    GIT_WORK_TREE="$1" GIT_DIR="$1"/.git git rev-parse --show-toplevel > /dev/null 2>&1 || return 1
    f="$(GIT_WORK_TREE="$1" GIT_DIR="$1"/.git git ls-files | fzf)"
    [ "$f" ] || return 2
    $EDITOR "$1"/"$f"
}

if false
then
    # Wrapper to automatically add the key
    # could have been alias='SSH_ASKPASS=askpass SSH_ASKPASS_REQUIRE=prefer ssh'
    # but this option is very slow for some reason
    ssh()
    {
     for arg in $@; do
      if grep "Host $arg\s*\$" ~/.ssh/config > /dev/null 2>&1 ;
      then
       Logging=0 keyadd "$arg"
       break
      fi
     done
     /usr/bin/ssh $@
    }
fi

ssl_req()
{
    [ "$1" ] || return 1
    [ "$2" ] || return 2
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out "$1" -keyout "$2"
}

trclipo()
{
    magnet="$(clipo)"
    if ! printf '%s\n' "$magnet" | grep '^magnet:' > /dev/null 2>&1
    then
        >&2 printf 'Not a magnet.\n'
        return 1
    fi

    category="$(printf "music\nanime\nmovies\nshows\nother\nsoftware\ngames\nisos\nbooks\n" | fzf)"
    [ "$category" ] || return 2

    transmission-remote autumn -a -w "/downloads/$choice" "$magnet"
}

debinstall()
{
 if [ "$1" ]
 then
  ar p "$1" data.tar.xz |
   tar -xv -J; find usr -type f |
   while read -r file
   do
    >&2 printf 'cp %s /usr/local/%s\n' "$file" "${file#usr/}"
    doas cp "$file" "/usr/local${file#usr}"
   done
  else
   >&2 printf 'usage: %s <source.deb>\n' "$0"
 fi
}
