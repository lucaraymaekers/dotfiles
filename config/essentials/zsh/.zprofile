#!/bin/sh

if { [ "$TTY" = "/dev/tty1" ] || [ "$TTY" = "/dev/tty8" ]; } &&
    [ "$(id -u)" -ne 0 ]; then
    exec startx > /dev/null 2>&1
    exit
fi
