SHELL=/bin/bash
PATH=$HOME/bin:$PATH
color1="\[\033[35m\]"
color2="\[\033[36m\]"
bold="\[\033[1m\]"
reset="\[\033[0m\]"
PS1="${color1}${bold} [\\u${reset}@${color2}${bold}\\h]${reset} \\w "
HISTFILE=
. $HOME/.config/zsh/aliases.sh
