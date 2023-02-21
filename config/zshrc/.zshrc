#!/bin/zsh

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

test -f ~/.config/zsh/variables.zsh && source ~/.config/zsh/variables.zsh

if [ ! $(pgrep Xorg) ] && [ "tty1" = "$(basename $(tty))" ]
then
	clear
	eval `keychain --eval --quiet --agents gpg 3A626DD20A32EB2E5DD9CE71CFD9ABC97158CD5D`
	eval `keychain --noask --eval --quiet --agents ssh`
    startx 2&> /dev/null
    exit
fi

autoload -U select-word-style
select-word-style bash
autoload -z edit-command-line
zle -N edit-command-line
zstyle ':compinstall' filename '/home/aluc/.zshrc'
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -v
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround
bindkey "^A"  beginning-of-line
bindkey "^E"  end-of-line
# necessary for completeinword
bindkey '^I' expand-or-complete-prefix
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

setopt prompt_subst
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
}
parse_git_status() {
	git status --short 2> /dev/null | head -n1 | awk '{print $1 " "}'
}
PS1=' %B%(#.%F{1}.%F{13})[%n%b%f@%B%F{6}%m]%b%f %3~ '
RPROMPT='%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f%(?.. %?)'

# Options
setopt correct 
#I am scared of "no matches found"
setopt nonomatch 
setopt autocd
setopt completeinword
setopt extendedglob
setopt histignorealldups
setopt histreduceblanks
setopt interactivecomments
setopt notify
setopt cdablevars

for f in \
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
	~/.config/zsh/functions.zsh \
	~/.config/zsh/aliases.zsh
do
	test -f $f && source $f
done

HISTFILE=~/.config/zsh/histfile
HISTSIZE=100000
SAVEHIST=100000
