#!/bin/sh
#
# pastes the selected kaomoji into your currently focused window
# kaomoji list downloaded from:
# https://github.com/fdw/rofimoji/raw/refs/heads/main/src/picker/data/kaomoji.csv

# show kaomoji list with rofi and get selection
CHOICE=$(rofi -dmenu -p "" -config "${HOME}/.config/rofi/emoji.rasi" -i -l 12 < "${HOME}/.local/share/kaomoji")

# exit if no choice
[ "$CHOICE" ] || exit

# remove any words after the kaomoji
CHOICE="${CHOICE%% *}"

# copy selected kaomoji to clipboard
echo -n "$CHOICE" | xclip -i

# Paste the kaomoji using xdotool (middle mouse click)
xdotool click 2

exit 0
