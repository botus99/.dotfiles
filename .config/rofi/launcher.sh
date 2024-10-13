#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)


dir="$HOME/.config/rofi"
theme='launcher'

lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"

## Run
rofi \
    -show drun \
    -mesg "  Last Login: $lastlogin |   Uptime: $uptime" \
    -theme ${dir}/${theme}.rasi
