#!/bin/zsh
export EDITOR="vis"
export VISUAL="vis"

export BROWSER="zen-browser"
export VIEWER="zathura"
export PLAYER="mpv"

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export CARGO_HOME="$XDG_CONFIG_HOME"/cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GOPATH="$XDG_DATA_HOME"/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export NVM_DIR="$XDG_DATA_HOME"/nvm
export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export RANDFILE="$XDG_CACHE_HOME"/rnd
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export TNS_ADMIN=/opt/oracle/instantclient_21_9/network/admin
export W3M_DIR="$XDG_STATE_HOME"/w3m
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export WINEPREFIX="$XDG_DATA_HOME"/wine
export XCURSOR_PATH=/usr/share/icons:"$XDG_DATA_HOME"/icons
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias irssi='irssi --config="$XDG_CONFIG_HOME"/irssi/config --home="$XDG_DATA_HOME"/irssi'
alias mbsync='mbsync -c "$XDG_CONFIG_HOME"/isync/mbsyncrc'

export XINITRC="$XDG_CONFIG_HOME"/x11/xinitrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority

export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export HISTFILE="$ZDOTDIR"/histfile
export HISTSIZE=100000
export SAVEHIST=100000
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export QT_QPA_PLATFORMTHEME="qt5ct"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# export _JAVA_AWT_WM_NONREPARENTING=1
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

export PASSWORD_STORE_DIR="$HOME"/src/password-store
export PASSWORD_STORE_CLIP_TIME=5

# old
# export RANGER_LOAD_DEFAULT_RC=FALSE
# export VIMINIT="source ~/.config/vim/vimrc"
# export fpath=($XDG_CONFIG_HOME/zsh/completion/ $fpath)
# export CUDA_CACHE_PATH="$XDG_CONFIG_HOME"/nv

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,hl:#88c0d0
	--color=pointer:#6d96a5
	--color=gutter:#2e3440
    --color=fg+:#81a1c1,hl+:#ebcb8b
    --color=info:#b48ead,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#ebcb8b,header:#a3be8b'

export LESS="-i -r"

# Colored manpages
# export MANPAGER="less -R --use-color -Dd+r -Du+b"
# export MANROFFOPT="-P -c"

export CM_LAUNCHER="commander -c"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$XDG_CONFIG_HOME/cargo/bin:$PATH"
export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$GOPATH/bin"

export PLAN9=/usr/lib/plan9
export PATH="$PATH:$PLAN9/bin"

export SSH_ASKPASS=askpass
export SSH_ASKPASS_REQUIRE=prefer
