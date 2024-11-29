### Completion
# Find most of the stuff at https://github.com/zap-zsh/completions

export ZSH_COMPDUMP="$ZDOTDIR"/zcompcache

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
autoload -Uz compinit; compinit

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

_ws_complete() {
    local -a subcmds
    ws help 2>&1 |
        tail -n +3 | # skip usage and COMMANDS line
        sed -e 's/\s*\([^ ]\+\)\s*\(.\+\)/\1: \2/' |
        while read -r line; do
            subcmds+=("$line")
        done
    _describe 'ws commands' subcmds 
}
compdef _ws_complete ws

_go_flag_complete() {
    local -a subcmds
    $name -h  2>&1 | tail -n +2 |
    while read -r l1; do
        read -r l2
        l1="$(printf '%s' "$l1" | sed 's/^\s*\([^ ]\+\).*/\1/')"
        l2="$(printf '%s' "$l2" | sed 's/^\s*//')"
        subcmds+=("$l1: $l2")
    done
    _describe 'commands' subcmds
}

compdef _gnu_generic cpp sqlplus apropos
compdef _gnu_generic air
compdef _go_flag_complete wbr
compdef esc="which"
compdef gdbcore="which"
compdef pkgfile="which"
#compdef ytui
compdef _ytui ytui

# zsh completion for ytui                                 -*- shell-script -*-

__ytui_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_ytui()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __ytui_debug "\n========= starting completion logic =========="
    __ytui_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __ytui_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __ytui_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., ytui -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __ytui_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __ytui_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __ytui_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __ytui_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __ytui_debug "No directive found.  Setting do default"
        directive=0
    fi

    __ytui_debug "directive: ${directive}"
    __ytui_debug "completions: ${out}"
    __ytui_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __ytui_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __ytui_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __ytui_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __ytui_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __ytui_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __ytui_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __ytui_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __ytui_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __ytui_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __ytui_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __ytui_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __ytui_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __ytui_debug "_describe did not find completions."
            __ytui_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __ytui_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __ytui_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_ytui" ]; then
    _ytui
fi
