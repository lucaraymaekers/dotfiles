#!/bin/sh

# Show which C header needs to be included for '$1' by looking at the manpages for that keyword.

{ man -c 2  "$1" ||
  man -c 3p "$1" ||
  man -c 3  "$1"; } 2>/dev/null | col -b |
grep -m 1 -o '#include <[^>]\+>'
