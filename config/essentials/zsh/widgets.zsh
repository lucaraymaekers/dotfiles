# Surround line in variable
surround_in_var()
{
    BUFFER=" \"\$($BUFFER)\""
    zle beginning-of-line
}
zle -N surround_in_var
bindkey '\ev' surround_in_var

# Insert output from the previous command
zmodload -i zsh/parameter
insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey "^Xl" insert-last-command-output

# 
