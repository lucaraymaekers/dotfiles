#!/bin/zsh

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

export XINITRC="$HOME/.config/x11/xinitrc"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"

export CARGO_HOME=~/.config/cargo
export GNUPGHOME="$HOME/.config/gnupg"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export QT_QPA_PLATFORMTHEME="qt5ct"

export _JAVA_AWT_WM_NONREPARENTING=1

export PASSWORD_STORE_CLIP_TIME=5

if [ ! $(pgrep Xorg) ] && [ "tty1" = "$(basename $(tty))" ]
then
	clear
	eval "$(keychain --dir "$HOME/.config/keychain" --eval --quiet --agents gpg 3A626DD20A32EB2E5DD9CE71CFD9ABC97158CD5D 2> /dev/null)"
	eval "$(keychain --dir "$HOME/.config/keychain" --noask --eval --quiet --agents ssh 2> /dev/null)"
	clear
    startx 2&> /dev/null
    exit
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

for f in \
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
	~/.config/zsh/functions.zsh \
	~/.config/zsh/aliases.zsh
do
	test -f $f && source $f
done

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

# pacman synced rehash
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
add-zsh-hook -Uz precmd rehash_precmd

# prompt
PS1=' %B%(#.%F{1}.%F{13})[%n%b%f@%B%F{6}%m]%b%f %3~ '
RPROMPT='%F{blue}$(parse_git_remote)%f%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f%(?.. %?)'

setopt prompt_subst
parse_git_remote() {
	b="$(git branch -v 2> /dev/null | grep "^*" | sed 's/.\+\[\([^ ]\+\).*$/\1/')"
	if [ "$b" = "behind" ]
	then
		echo -n "↓ "
	elif [ "$b" = "ahead" ]
	then
		echo -n "↑ "
	fi
}
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
}
parse_git_status() {
	git status --short 2> /dev/null | head -n1 | awk '{print $1 " "}'
}

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

# Variables
HISTFILE=~/.config/zsh/histfile
HISTSIZE=100000
SAVEHIST=100000

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
ZOT="${HOME}/zot"

# old
# export RANGER_LOAD_DEFAULT_RC=FALSE
# export VIMINIT="source ~/.config/vim/vimrc"
# export NVM_DIR="$HOME/.config/nvm"
# export fpath=($HOME/.config/zsh/completion/ $fpath)
