#!/usr/bin/env bash

dwm_keybindings_file="$HOME/.config/rofi/macros.txt"
sxhkdrc_file="$HOME/.config/suckless/sxhkd/sxhkdrc"

# Read dwm keybindings (first section)
dwm_bindings=$(awk -F'\t' '
    { printf "dwm  |%-30s|%-30s\n", $1, $2 }
' "$dwm_keybindings_file")

# Parse sxhkdrc keybindings (second section)
sxhkd_bindings=$(awk '
    /^[a-z]/ && last { 
        printf "sxhkd|%-30s|%-30s\n", $0, last 
    }
    { last="" } 
    /^#/ { last=substr($0, 3) }' "$sxhkdrc_file")

# Combine with DWM first
combined_bindings="$dwm_bindings"$'\n'"$sxhkd_bindings"

# Format for rofi display
formatted_keybindings=$(echo "$combined_bindings" | column -t -s '|')

# Show combined list in rofi
selected=$(echo "$formatted_keybindings" | rofi -dmenu -i -p "" -hide-scrollbar -theme ~/.config/rofi/macros.rasi)

# Check if user selected something
if [ -n "$selected" ]; then
    # Determine if it's from sxhkd (and executable)
    source=$(echo "$selected" | awk '{print $1}')
    if [[ "$source" == "sxhkd" ]]; then
        command=$(echo "$selected" | awk -F'|' '{print $3}' | xargs)
        if [ -n "$command" ]; then
            nohup $command &>/dev/null &
        fi
    fi
fi
