#!/bin/zsh
# VARIABLES
export ZOT="${HOME}/zot"

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Prevent ranger from loading config twice
export RANGER_LOAD_DEFAULT_RC=FALSE

# Color of zsh-suggestion
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
export FUNCNEST=10000
export fpath=($HOME/.config/zsh/completion/ $fpath)

# Config files from .config
export XINITRC="$HOME/.config/x11/xinitrc"
export GNUPGHOME="$HOME/.config/gnupg"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
# export VIMINIT="source ~/.config/vim/vimrc"
export NVM_DIR="$HOME/.config/nvm"

export PASSWORD_STORE_CLIP_TIME=5
