#!/bin/sh

die () { >&2 printf '%s\n' "$@"; exit 1; }

[ $# -eq 0 ] &&
    die 'No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>'

if [ -t 0 ]
then 
    file="$1"
    file_name="$(basename "$file")"
    [ -e "$file" ] ||
        die "$file: No such file or directory\n"
    if [ -d "$file" ]
    then 
        file_name="$file_name".zip
        (cd "$file" && zip -r -q - .) | curl --upload-file - "https://transfer.sh/$file_name"
    else
        curl --upload-file "$file" "https://transfer.sh/$file_name"
    fi
else 
    file_name="$1"
    curl --upload-file - "https://transfer.sh/$file_name"
fi
