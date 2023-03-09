#!/bin/zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

test ! -d "$XDG_CONFIG_HOME"/x11 &&
	mkdir "$XDG_CONFIG_HOME"/x11
export XINITRC="$XDG_CONFIG_HOME/x11"/xinitrc
# export XAUTHORITY="$XDG_RUNTIME_DIR/x11"/Xauthority
export CARGO_HOME="$XDG_CONFIG_HOME"/cargo
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export CUDA_CACHE_PATH="$XDG_CONFIG_HOME"/nv
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NVM_DIR="$XDG_DATA_HOME/nvm"
export W3M_DIR="$XDG_STATE_HOME"/w3m

export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export HISTFILE="$ZDOTDIR"/histfile
export HISTSIZE=100000
export SAVEHIST=100000
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export QT_QPA_PLATFORMTHEME="qt5ct"

export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

export PASSWORD_STORE_CLIP_TIME=5

# old
# export RANGER_LOAD_DEFAULT_RC=FALSE
# export VIMINIT="source ~/.config/vim/vimrc"
# export fpath=($XDG_CONFIG_HOME/zsh/completion/ $fpath)
