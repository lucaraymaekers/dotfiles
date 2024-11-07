# Surround line in variable
surround_in_var() {
	BUFFER=" \"\$($BUFFER)\""
	zle beginning-of-line
}
zle -N surround_in_var
bindkey '\ev' surround_in_var

# Insert output from the previous command
zmodload -i zsh/parameter
insert-last-command-output() {
	LBUFFER+="$(eval $history[$((HISTCMD - 1))])"
}
zle -N insert-last-command-output
bindkey "^Xl" insert-last-command-output


toggle_prompt() {
    local new_prompt=' $ '
    if [ "$PS1" = "$new_prompt" ]; then
        eval "$(starship init zsh)"
    else
        PS1="$new_prompt"
    fi
    zle clear-screen
}
zle -N toggle_prompt
bindkey '\ep' toggle_prompt


bindkey -s '\eF' "tmux-sessionizer\n"

