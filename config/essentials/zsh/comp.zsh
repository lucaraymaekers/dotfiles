### Completion
# Find most of the stuff at https://github.com/zap-zsh/completions

ZSH_COMPDUMP="$ZDOTDIR"/zcompcache

zmodload zsh/complist
zstyle ':compinstall' filename '/home/aluc/.zshrc'
# cache
zstyle ':completion:*' cache-path "$ZSH_COMPDUMP"
zstyle ':completion:*' use-cache on

# completers
zstyle ':completion:*' completer _extensions _complete

# format
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D%d --%f'
zstyle ':completion:*:*:*:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# show a 'ls -a' like outptut when listing files
zstyle ':completion:*' file-list all
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' file-sort date

# automatically find new executables in PATH
zstyle ':completion:*' rehash true

# Group completions by categories
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

zstyle ':completion:*' squeeze-slashes true

# Prefer completing for an option (think cd -)
zstyle ':completion:*' complete-options true

# keep prefix when completing
zstyle ':completion:*' keep-prefix true

# ui
zstyle ':completion:*' menu select

fpath=($ZDOTDIR/completions $fpath)
autoload -Uz compinit; compinit -d "$ZSH_COMPDUMP"

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}
compdef _dotnet_zsh_complete dotnet
compdef _gnu_generic cpp sqlplus

