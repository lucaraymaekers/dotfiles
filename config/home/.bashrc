SHELL=/bin/bash
PATH=$HOME/bin:$PATH
# color1="\[\033[35m\]"
# color2="\[\033[36m\]"
# color3="\[\033[40m\]"
# color4="\[\033[38m\]"
# bold="\[\033[1m\]"
# reset="\[\033[0m\]"
# PS1="${color1}${bold} ${color3}\\u${reset}${color3}${color4}@${color2}${bold}\\h${reset}${color3} \\w${reset} "
PS1=' \w $ '
HISTFILE=
. $HOME/.config/shell/aliases.sh 
. $HOME/.config/shell/functions.sh
