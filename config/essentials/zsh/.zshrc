#!/bin/zsh

if [ "$(id -u)" -ne 0 ]
then
	[ "${TTY%%tty*}" = '/dev/' ] && clear
	case "${TTY#/dev/tty}" in
		1) exec startdwl > /dev/null 2>&1 ;;
		2) exec startx > /dev/null 2>&1 ;;
		3) exec startw > /dev/null 2>&1 ;;
		*) false ;;
	esac && exit
fi

autoload -U select-word-style
autoload -z edit-command-line
zle -N edit-command-line
zstyle ':compinstall' filename '/home/aluc/.zshrc'
zstyle ':completion:*' menu select
autoload -Uz compinit
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
compinit

# Source files
. $ZDOTDIR/functions.zsh
. $ZDOTDIR/aliases.sh

for file in /etc/os-release /usr/lib/os-release
do [ -f "$file" ] && . "$file" && break
done
case "${ID:=unknown}" in
	debian|ubuntu) PLUGPATH=/usr/share/ ;;
	*) PLUGPATH=/usr/share/zsh/plugins ;;
esac
. $PLUGPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. $PLUGPATH/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -v
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround
bindkey "^A"  beginning-of-line
bindkey "^E"  end-of-line
bindkey '^I' expand-or-complete-prefix # necessary for completeinword
bindkey '^Y' autosuggest-accept
bindkey "^K"  kill-line
bindkey "^P"  up-line-or-history
bindkey "^N"  down-line-or-history
bindkey "^V"  quoted-insert
bindkey "^Xa" _expand_alias
bindkey "^Xe" edit-command-line
bindkey "^[." insert-last-word
bindkey "^['" quote-line

isTextFile()
{
	[ -f "$1" ] &&
		# will execute the file, I'd rather not have an error message
		[ ${1::2} != "./" ] &&
		[ ${1::1} != "/" ] &&
		! type "$1" > /dev/null &&
		# is text file?
		file -b --mime-type "$1" | grep -q "^text/" ||
		return 1
}

# rehash hook
zshcache_time="$(date +%s%N)"
autoload -Uz add-zsh-hook
rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}
# window title hooks
add-zsh-hook -Uz precmd rehash_precmd
set_wt_action () {
	print -n "\e]0;$1\a\033[0m"
}
add-zsh-hook -Uz preexec set_wt_action
set_wt () {
	print -Pn "\e]0;%n@%m on %~\a"
}
add-zsh-hook -Uz precmd set_wt
function osc7 {
    local LC_ALL=C
    export LC_ALL

    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7
command_not_found_handler () {
	if [[ -o interactive ]] && isTextFile "$1"
	then
		"$EDITOR" "$1"
	else
		echo "zsh: command not found: $1" >&2
	fi
}

# prompt
PS1=' %B%(#.%F{1}.%F{13})[%n%b%f@%B%F{6}%m]%b%f %3~ '
RPROMPT='%F{blue}$(parse_git_remote)%f%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f%(?.. %?)'

setopt prompt_subst
parse_git_remote() {
	git branch -v 2>/dev/null |
		grep '^\*' | cut -f2 -d'[' | cut -f1 -d' ' |
		sed 's/ahead/↑ /;s/behind/↓ /;s/\*//'
}
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
}
parse_git_status() {
	git status --short 2> /dev/null | head -n1 | awk '{print $1 " "}'
}

# Completion
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}
compdef _dotnet_zsh_complete dotnet

export REPORTTIME=2
export TIMEFMT="-> %*E"
# override built-in time command
alias time='/usr/bin/time'
export MENUCMD='fzf'

# Options
setopt correct 
setopt nonomatch 
setopt autocd
setopt completeinword
setopt extendedglob
setopt histignorealldups
setopt histreduceblanks
setopt interactivecomments
setopt notify
setopt cdablevars
