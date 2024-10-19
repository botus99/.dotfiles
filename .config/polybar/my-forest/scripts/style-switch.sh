#!/usr/bin/env bash

SDIR="$HOME/.config/polybar/my-forest/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $SDIR/rofi/styles.rasi \
<<< "󰨇  Default|  Nord|  Gruvbox|  Dark|  Catpuccin|  Cherry|")"
            case "$MENU" in
				*Default) "$SDIR"/styles.sh --default ;;
				*Nord) "$SDIR"/styles.sh --nord ;;
				*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
				*Dark) "$SDIR"/styles.sh --dark ;;
				*Catpuccin) "$SDIR"/styles.sh --catpuccin ;;
				*Cherry) "$SDIR"/styles.sh --cherry ;;
            esac
