#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)

dir="$HOME/.config/rofi"
theme='launcher'

## Run
rofi \
    -show drun \
    -theme "${dir}"/${theme}.rasi
