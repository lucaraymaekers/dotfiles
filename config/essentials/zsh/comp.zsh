# ### Completion

# autoload -Uz compinit; compinit
# zstyle ':compinstall' filename '/home/aluc/.zshrc'
# # cache
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$ZDOTDIR/zcompcache"

# # completers
# zstyle ':completion:*' completer _extensions _complete

# # format
# zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D%d --%f'
# zstyle ':completion:*:*:*:*:messages' format '%F{purple}-- %d --%f'
# zstyle ':completion:*:*:*:*:warnings' format '%F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# # show a 'ls -a' like outptut when listing files
# zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# # Group completions by categories
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# zstyle ':completion:*' squeeze-slashes true

# # Prefer completing for an option (think cd -)
# zstyle ':completion:*' complete-options true

# # keep prefix when completing
# zstyle ':completion:*' keep-prefix true

# # ui
# zstyle ':completion:*' menu select

# _dotnet_zsh_complete()
# {
#   local completions=("$(dotnet complete "$words")")

#   # If the completion list is empty, just continue with filename selection
#   if [ -z "$completions" ]
#   then
#     _arguments '*::arguments: _normal'
#     return
#   fi

#   # This is not a variable assignment, don't remove spaces!
#   _values = "${(ps:\n:)completions}"
# }
# compdef _dotnet_zsh_complete dotnet