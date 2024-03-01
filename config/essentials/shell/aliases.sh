#!/bin/sh
# s/alias \([^-]\)/alias -g \1

# The most important one
alias vi='nvim'

# Zsh specific aliases
if [ $SHELL = "/bin/zsh" ]
then
	# googoo aliases
	alias o~='o $HOME'
	alias o/='o /'
	alias o/s='o /srv'
	alias go~='go $HOME'
	alias go/='go /'
	alias go/s='go /srv'
	alias ogo~='ogo $HOME'
	alias ogo/='ogo /'
	alias ogo/s='ogo /srv'

	alias calc='bc <<<'

	if [ -z "$WAYLAND_DISPLAY" ]
    then
		if which devour > /dev/null 2>&1  
		then
			alias mpv='devour mpv'
			alias zathura='devour zathura'
		fi
	fi
	alias clipic='clipo > /tmp/pic.png'

	alias -g '...'='../..'
	alias -g '....'='../../..'
	alias -g bg='&; disown'
	alias -g hl='--help |& less -r'
fi


if grep -qi "debian\|ubuntu" /etc/os-release 2> /dev/null
then
	alias aptup='apt update && apt upgrade -y'
	alias ufwd='while echo y | ufw delete "$(ufw status numbered | tail -n +5 | fzf | cut -f2 -d'\''['\'' | cut -f1 -d'\'']'\'')" > /dev/null 2>&1 && >&2 echo "deleted."; do :; done'
fi

# Programs
alias nb='newsboat'
alias nr='newsraft'
alias sr='surfraw'
alias ccu='calcurse'
alias pf='profanity'

alias gurk='pgrep gurk > /dev/null && printf "Already Running.\n" || gurk'

alias arduino-cli='arduino-cli --config-file $XDG_CONFIG_HOME/arduino15/arduino-cli.yaml'

if [ -x /usr/bin/dircolors ] || [ -x $HOME/../usr/bin/dircolors ]
then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # alias ls='ls -h --color --group-directories-first'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ip='ip -color=auto'
    alias ipa='ip -br a'
fi

alias l='ls -l'
alias l1='ls -1'
alias ll='ls -la'
alias la='ls -aF'
alias lst='ls --tree'
alias lst1='ls --tree -L1'
alias lst2='ls --tree -L2'
alias lst3='ls --tree -L3'
alias ls.='ls -dl .*'
which eza >/dev/null 2>&1 &&
	alias ls='eza --sort extension --group-directories-first --no-time --git' ||
	alias ls='ls --color --group-directories-first --sort=extension'

# pacman aliases
alias pac='pacman'
alias pacsi='pac -Si'
alias pacs='pac -Ss'
alias pacq='pac -Q'
alias pacql='pac -Ql'
alias pacqs='pac -Qs'
alias paci='pac -Qi'

alias pacup='dopac -Syu'
alias dopac='doas pacman'
alias orpac='pacman -Qtdq | dopac -Rns - 2> /dev/null || echo "No orphans."'
alias dopacs='dopac -S'
alias dopacc='dopac -Sc'
alias doprm='dopac -Rns'

alias mpkg='makepkg -si'

which pikaur > /dev/null 2>&1 && alias yay='MAKEFLAGS="-j $(nproc)" pikaur'
alias yup='yay -Syu'
alias ysi='yay -Si'
alias yss='yay -Ss'
alias yqs='yay -Qs'
alias yql='yay -Ql'
alias yays='yay -S'
alias yrm='yay -Rns'

alias pkb='pkgfile -b'

# transmission
alias trr='transmission-remote debuc.com'
alias trls='transmission-remote debuc.com -t all -l'
alias tradd='transmission-remote debuc.com -a'
alias trclipo='transmission-remote debuc.com -a "$(clipo)"'

alias grub-update='doas grub-mkconfig -o /boot/grub/grub.cfg'

# vim
alias vimp="vim '+PlugInstall'"
alias nvimp="nvim '+PackerSync'"
alias nvg='git status > /dev/null 2>&1 && nvim "+Git"'
alias nvn='nvim "+Telekasten panel"'
 
alias xrandr-rpgmaker='xrandr --auto --output VGA-1 --mode 1024x768 --left-of HDMI-1 && ~/.fehbg'
alias xrandr-default='xrandr --auto --output VGA-1 --mode 1920x1080 --left-of HDMI-1 --output HDMI-1 --mode 1920x1080 && ~/.fehbg'
alias xrhdmi='xrandr --auto --output HDMI-4 --left-of DP-1-2'
 
alias d='du -d 0 -h'
alias dud='du .* * -d 0 -h 2>/dev/null | sort -h'
alias df='df -h'
alias diff='diff -u --color'
alias shred='shred -uz'
alias lsblk='lsblk -o name,type,fsused,fsavail,size,fstype,label,mountpoint'
alias sxt='sxiv -t'
alias wgsh='wget --quiet --show-progress'
alias wgc='wgsh "$(clipo)"'
alias ss4='ss -tln4p'
alias mdb='mariadb -u admin -ppass admindb'
alias mdbw='mariadb -h 0.0.0.0 -u padmin -pbulbizarre padmindb'
alias mdbwa='mariadb -h 10.3.50.5 -u padmin -pbulbizarre padmindb'
alias tmux='pgrep tmux && tmux attach || tmux new-session'

# ssh
alias sha='ssh-add'
alias sshs='eval "$(ssh-agent)" && ssh-add'
alias vidlen='ffprobe -show_entries format=duration -v quiet -of csv="p=0" -i'
alias whatsmyip='curl -s "ifconfig.co"'
alias icognito='unset HISTFILE'
alias webcam='v4l2-ctl --set-fmt-video=width=1280,height=720; mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video0 --profile=low-latency --untimed --no-resume-playback'
alias capture='echo "Y" | wf-recorder -o "$(hyprctl -j monitors | jq -r '\''.[].name'\'' | fzf)" --codec=vp8_vaapi --device=/dev/dri/renderD128 -f output.webm -D'
alias qrclipo='qrencode -s 16 "$(clipo)" -o - | imv -w "imv - $(clipo)" -'
alias airpods='bluetoothctl connect 60:93:16:24:00:10'
alias hotpsot='nmcli dev wifi hotspot ifname wlan0 ssid wiefie password "peepeepoopoo"'
alias wtip='wt ip -c -brief addr'
alias fusephone='sshfs myphone: /media/phone'
alias ttyper='ttyper -l english1000'

alias wgup='doas wg-quick up wg0'
alias wgdown='doas wg-quick down wg0'

# NPM
alias npi="npm init --yes"

# Python
alias penv='python3 -m venv env'
alias phttp='python3 -m http.server'
alias pipreq='pip install -r requirements.txt'

alias ch='chown ${USER}:${USER} -R'
alias kll='killall'
alias pi='ping 9.9.9.9 -c4'
alias sba='source env/bin/activate || source bin/activate'

alias zsr='source ${ZDOTDIR:-~}/.zshrc && rehash'
alias rh='rehash'
alias wf='doas wipefs -a'
alias dmci="doas make clean install"
alias rmd='rm -f *.{orig,rej}'
alias cdzot='mkdir -p /tmp/zottesite && cd /tmp/zottesite'
alias gdate='date +%y_%m_%d-%T'
alias tpid='tail -f /dev/null --pid'
alias pwdcp='pwd | clipp'
alias gw="grep -ri"
alias srcsupd='echo ~/src/{installdrier,dotfiles,password-store} ~/proj/suckless/*/ ~/proj/personal/scripts/*/ ~/.config/emacs | supd'

# systemctl aliases
alias smc='systemctl'
alias smcs='systemctl status'
alias smcst='systemctl start'
alias smcS='systemctl stop'
alias smcr='systemctl restart'
alias smcrl='systemctl reload'
alias smcd='systemctl daemon-reload'
alias smce='systemctl edit'
alias smcen='systemctl enable'
#user
alias smcu='systemctl --user'
alias smcus='systemctl --user status'
alias smcust='systemctl --user start'
alias smcuS='systemctl --user stop'
alias smcur='systemctl --user restart'
alias smcurl='systemctl --user reload'
alias smcud='systemctl --user daemon-reload'
alias smcue='systemctl --user edit'
alias smcuen='systemctl --user enable'
#doas
alias dsmc='doas systemctl'
alias dsmcs='doas systemctl status'
alias dsmcst='doas systemctl start'
alias dsmcS='doas systemctl stop'
alias dsmcr='doas systemctl restart'
alias dsmcrl='doas systemctl reload'
alias dsmcd='doas systemctl daemon-reload'
alias dsmce='doas systemctl edit'
alias dsmcen='doas systemctl enable'

# virtualbox aliases
alias vbm='vboxmanage'
alias vbls='vbm list vms'
alias vblsr='vbm list runningvms'
alias vb='vbm startvm'

# quick config
alias ez='vi ${ZDOTDIR:-~}/.zshrc'
alias ezal='vi $HOME/.config/shell/aliases.sh'
alias ezf='vi $HOME/.config/shell/functions.sh'
alias eto='vi ~/sync/TODO'
alias edw='vi ~/proj/suckless/dwm/config.def.h'
alias edm='vi ~/proj/suckless/dmenu/config.def.h'
alias ehst='vi $ZDOTDIR/histfile'
alias ezh=' vi $HISTFILE'
alias est='vi ~/proj/suckless/st/config.def.h'
alias esl='vi ~/proj/suckless/slock/config.def.h'
alias esls='vi ~/proj/suckless/slstatus/config.def.h'
alias ehy='vi ~/.config/hypr/hyprland.conf'
alias ehyb='vi ~/.config/hypr/binds.conf'
alias ewbj='vi ~/.config/waybar/config.jsonc'
alias ewbs='vi ~/.config/waybar/style.css'
alias cfd='vi config.def.h'
# /# quick cdjV}k:!sort -t "'" -k 2
alias cdl='cd ~/dl'
alias cdoc='cd ~/docs'
alias czk='cd ~/docs/zk'
alias cda='cd ~/docs/android/projects'
alias csv='cd ~/docs/school/Vakken'
alias cdpj='cd ~/docs/school/Vakken/ITProj'
alias cdm='cd ~/music'
alias cdp='cd ~/pics'
alias cdpa='cd ~/pics/ai-outputs/'
alias cdpp='cd ~/proj/personal/'
alias chom='cd ~/proj/personal/homepage'
alias lov='cd ~/proj/personal/lola'
alias cdsh='~/proj/personal/scheduler'
alias cdsw='cd ~/proj/personal/WheelAdvisor'
alias cddm='cd ~/proj/suckless/dmenu'
alias cdw='cd ~/proj/suckless/dwm'
alias cdslo='cd ~/proj/suckless/slock'
alias cdsl='cd ~/proj/suckless/slstatus'
alias cdst='cd ~/proj/suckless/st'
alias cdsta='cd ~/proj/suckless/stable-diffusion-webui'
alias cdsu='cd ~/proj/suckless/surf'
alias cds='cd ~/src/'
alias cdsb='cd ~/src/build'
alias cdsc='cd ~/src/comfyui/'
alias cdo='cd ~/src/dotfiles'
alias cdi='cd ~/src/installdrier'
alias cdia='cd ~/src/installdrier/arch'
alias cdib='cd ~/src/installdrier/deb'
alias czo='cd ~/zot/'
alias cdpw='cd ${PASSWORD_STORE_DIR:-~/.password-store}'
alias cdng='cd /etc/nginx'
alias cdrs='cd /srv/'
alias cdv='cd ~/vids'
alias god='cd "$(find . -mindepth 1 -maxdepth 1 -type d | fzf)"'
alias gov='go ~/vids d'

# fzf aliases
alias ppj='cd ~/proj/personal/"$(find ~/proj/personal -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)"'
alias ppjs='cd ~/proj/personal/scripts/"$(find ~/proj/personal/scripts -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)"'
alias scr='edit_in_dir ~/proj/personal/scripts/'
alias fil='edit_in_dir ~/docs/filios/'
alias fzps='ps aux | tail +2 | fzf | tee /dev/stderr | awk '\''{print $2}'\'' | clipp'
alias asf='alias | fzf'
alias fzh="fzf --tac < $HISTFILE | tee /dev/stderr | clipp"
alias ffwin='hyprctl clients -j | jq '\''.[].pid'\'' | fzf --preview "hyprctl clients -j | jq '\''.[] | select(.pid == {}) | {class, title, workspace, xwayland}'\''"'
alias pff='find ${PASSWORD_STORE_DIR:=~/src/password-store/} -name "*.gpg" | sed -e "s@$PASSWORD_STORE_DIR/@@" -e '\''s/\.gpg$//'\'' | fzf | xargs pass show -c'
alias fzps='fzf --print0 | xargs -0I{}'
alias ytdl='yt-dlp --restrict-filenames --embed-chapters -f "b" -S "res:1080" -P "$HOME/vids/youtube/" -o "%(channel)s/%(title)s.%(ext)s"'
alias ytplay='mpv "$(ytlink)"'

# emacs aliases
alias emacsd='emacs --daemon'
alias emacsdbg='emacs --debug-init'
alias e='emacsclient -c -a "emacs"'

# docker aliases
alias dcb='docker build'
alias dcbt='docker build -t'
alias dce='docker exec'
alias dcet='docker exec -it'
alias dcmp='docker compose up -d'

# dotnet aliases
alias dncns='dotnet new console --use-program-main -o'

# debuc aliases
alias dbadd='ssh db dladd "'\''$(clipo)'\''"'
alias dbcons='ssh -t db dlcons'
alias dbinf='ssh db dlinfo'
alias sshdb='ssh -t db "tmux a || tmux"'
alias dbsmu='rsync -rlpP db:/media/basilisk/music/ /media/kilimanjaro/music'

# git
alias config='GIT_WORK_TREE=~/src/dotfiles/ GIT_DIR=~/src/dotfiles/.git'
alias cfg='vi ~/src/dotfiles/"$(config git ls-files | fzf || exit)"'
alias gmod='git status --short | sed '\''/^\s*M/!d;s/^\s*M\s*//'\'' | fzf | xargs vi'
alias gclc='git clone "$(clipo)"'

# docker
alias dorm='docker container rm $(docker container ls -a | tail -n +2 | fzf -m | awk '\''{print $1}'\'')'
alias dostop='docker container stop $(docker container ls -a | tail -n +2 | fzf -m | awk '\''{print $1}'\'')'
alias doirm='docker image rm $(docker image ls | tail -n +2 | fzf -m | awk '\''{print $3}'\'')'

alias -g skip='tail -n +2'
alias ddeps='pactree -r -d 1'
alias update-mirrors='reflector -p https | rankmirrors -n 10 -p -w - | doas tee /etc/pacman.d/mirrorlist'
