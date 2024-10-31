#!/bin/sh
man -s 2,3p,3 -P cat "$1" | grep -m 1 -o '#include <[^>]\+>'
