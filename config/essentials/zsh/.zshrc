#!/bin/zsh

export PATH="$PATH:$HOME/proj/metac/build"
export PATH="$PATH:$HOME/proj/metac/misc"
export PATH="$PATH:$HOME/src/4coder"

if { [ "$TTY" = "/dev/tty1" ] || [ "$TTY" = "/dev/tty8" ]; } && [ "$(id -u)" -ne 0 ]; then
    eval "$(keychain --dir "$XDG_CONFIG_HOME/keychain" --eval --quiet --agents ssh,gpg)"
    if [ "$(hostname)" = "spring" ]
    then
        keychain --dir "$XDG_CONFIG_HOME/keychain" --quiet --agents gpg 3A626DD20A32EB2E5DD9CE71CFD9ABC97158CD5D #FILTERED
    fi
    exec startx > /dev/null 2>&1
    exit
fi

# zmodload zsh/zprof

autoload -U select-word-style
autoload -z edit-command-line
zle -N edit-command-line

### Source files
try_source() { [ -f "$1" ] && . "$1"; } # source if exists
try_source /etc/grc.zsh
# try_source /etc/profile.d/plan9.sh
try_source $XDG_CONFIG_HOME/zsh/comp.zsh
try_source $XDG_CONFIG_HOME/shell/functions.sh
try_source $XDG_CONFIG_HOME/shell/aliases.sh
try_source $XDG_CONFIG_HOME/zsh/widgets.zsh
try_source $XDG_CONFIG_HOME/zsh/prompt.zsh
# try_source $XDG_CONFIG_HOME/zsh/plugins.zsh

### Programs
# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

### Plugins
if [ -f "$HOME/.local/share/zap/zap.zsh" ]
then
	. "$HOME/.local/share/zap/zap.zsh"
	# plug "MichaelAquilina/zsh-you-should-use"
	plug "chivalryq/git-alias"
	# plug "marlonrichert/zsh-autocomplete"
    # plug "wintermi/zsh-golang"
	plug "zap-zsh/fzf"
	plug "zdharma-continuum/fast-syntax-highlighting"
	plug "zsh-users/zsh-autosuggestions"
	plug "zsh-users/zsh-completions"
	plug "MichaelAquilina/zsh-auto-notify"
	export AUTO_NOTIFY_TITLE="zsh"
	export AUTO_NOTIFY_BODY="%command [%exit_code]"
	AUTO_NOTIFY_IGNORE+=("abduco" "gurk" "ttyper" "pulsemixer" "tmux" "btop" "vis" "clock" "server" "chatty" "pwsh")
fi

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
[ -n "$NNNLVL" ] && PS1="N$NNNLVL$PS1"

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
bindkey '\ea' autosuggest-toggle
bindkey '^Xp' push-input
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

## window title hooks
add-zsh-hook -Uz preexec () { print -n "\e]0;$1\a\033[0m"; }
set_wt() { print -Pn "\e]0;%n@%m on %~\a"; }
add_newline() { printf '\n'; }
precmd_functions+=(add_newline)
precmd_functions+=(set_wt)
# add-zsh-hook -Uz precmd add_newline() { printf '\n'; }

## automatic ls after cd
# add-zsh-hook -Uz chpwd (){ [ "$PWD" = "$HOME" ] || ls -A; }

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
# setopt cdablevars

# NOTE: depends on `tmux' alias
[ "$TMUX" ] || tmux
# zprof
