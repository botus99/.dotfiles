#!/usr/bin/env bash

layouts=(
    "󰕰 Default                   Shift+Control+1"    
    "󰙀 Floating                  Shift+Control+2"    
    "󰕮 Monocle                   Shift+Control+3"
    "󰪷 Spiral                    Shift+Control+4"   
    "󰕬 Columns                   Shift+Control+5"    
    "󱒈 Bstack                    Shift+Control+6"    
    "󰕭 N-Row Grid                Shift+Control+7"    
    "󰛇 Deck                      Shift+Control+8"    
    "󰕫 Centered-Vertical         Shift+Control+9"    
    "󰕯 Centered-Horizontal       Shift+Control+0"    
    "󰝘 Grid                      Shift+Control+-"    
    "󰕴 Dwindle                   Shift+Control+="    
)

selected=$(printf "%s\n" "${layouts[@]}" | rofi -dmenu -i -p "" -hide-scrollbar -theme ~/.config/rofi/layouts.rasi)

# Extract just the first two fields (layout name)
layout_name=$(echo "$selected" | awk '{print $1, $2}')

case "$layout_name" in
    "󰕰 Default") xdotool key shift+control+1 ;;
    "󰙀 Floating") xdotool key shift+control+2 ;;
    "󰕮 Monocle") xdotool key shift+control+3 ;;
    "󰪷 Spiral") xdotool key shift+control+4 ;;
    "󰕬 Columns") xdotool key shift+control+5 ;;
    "󱒈 Bstack") xdotool key shift+control+6 ;;
    "󰕭 N-Row") xdotool key shift+control+7 ;;
    "󰛇 Deck") xdotool key shift+control+8 ;;
    "󰕫 Centered-Vertical") xdotool key shift+control+9 ;;
    "󰕯 Centered-Horizontal") xdotool key shift+control+0 ;;
    "󰝘 Grid") xdotool key shift+control+minus ;;
    "󰕴 Dwindle") xdotool key shift+control+equal ;;
    *) exit 0 ;;  # Exit on cancel
esac
