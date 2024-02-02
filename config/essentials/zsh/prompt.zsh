# prompt
# PS1=' %K{16}%B%(#.%F{1}.%F{13})%n%b%f@%B%F{6}%m%b%f %3~%k '
# RPROMPT='%F{blue}$(parse_git_remote)%f%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f%(?.. %?)'

setopt prompt_subst
parse_git_remote() {
	git branch -v 2> /dev/null |
		awk -F '[][]' '/^\*/ {print $2}' |
		sed 's/ahead/↑ /;s/behind/↓ /;s/[^↓↑]*/ /g'
}
parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
}
parse_git_status() {
	git status --short 2> /dev/null | head -n1 | awk '{print $1 " "}'
}