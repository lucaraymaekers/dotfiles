#!/bin/zsh

if [ "$(id -u)" -ne 0 ]
then
	[ "${TTY%%tty*}" = '/dev/' ] && clear
	case "${TTY#/dev/tty}" in
		1) exec startx > /dev/null 2>&1 ;;
		2) exec startdwl > /dev/null 2>&1 ;;
		3) exec startw > /dev/null 2>&1 ;;
		*) false ;;
	esac && exit
fi

autoload -U select-word-style
autoload -z edit-command-line
zle -N edit-command-line
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

### Source files
. $XDG_CONFIG_HOME/shell/functions.sh
. $XDG_CONFIG_HOME/shell/aliases.sh
. $XDG_CONFIG_HOME/zsh/comp.zsh
# . $XDG_CONFIG_HOME/zsh/prompt.zsh
# . $XDG_CONFIG_HOME/zsh/plugins.zsh

### Programs
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

### Plugins
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
plug "kutsan/zsh-system-clipboard"
plug "xPMo/zsh-toggle-command-prefix"
plug "zap-zsh/vim"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-completions"
plug "zap-zsh/fzf"
plug "zdharma-continuum/fast-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "MichaelAquilina/zsh-you-should-use"

# Substring search settings
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Zsh System keyboard settings
if [ -n "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    ZSH_SYSTEM_CLIPBOARD_METHOD="xsc"
else
    ZSH_SYSTEM_CLIPBOARD_METHOD="wlc"
fi


# Add nnn shell level to prompt
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# cd on nnn quiting
nnn_cd ()
{
    if ! [ -z "$NNN_PIPE" ]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi
}

trap nnn_cd EXIT

# Check if in tmux and if a venv directory exists activate the python environment
if [ ! -z "$TMUX" ] && [ -d "./env" ]; then
    . ./env/bin/activate
fi

### Keybinds
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
## Move around using h j k l in completion menu
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xg' clear-screen
## interactive mode
bindkey -M menuselect '^xi' vi-insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

set_wt_action () {
	print -n "\e]0;$1\a\033[0m"
}
add-zsh-hook -Uz preexec set_wt_action
set_wt () {
	print -Pn "\e]0;%n@%m on %~\a"
}
add-zsh-hook -Uz precmd set_wt
## automatic ls after cd
add-zsh-hook -Uz chpwd (){[ "$PWD" != "$HOME" ] && ls -a; }

### Variables
## Run menuscripts with fzf
export MENUCMD='fzf'
## vi mode escape fix
export KEYTIMEOUT=1

### Options
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
