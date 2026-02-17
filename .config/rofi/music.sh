#!/usr/bin/env bash
set -euo pipefail

status=$(mpc status 2>/dev/null || true)

if [[ -z "$status" ]]; then
    notify-send "mpd offline"
    exit 1
fi

current=$(mpc current)

# ---- Parse state once ----
play_state=$(awk -F'[][]' '/\[/ {print $2}' <<< "$status")
random_state=$(awk '/random:/ {for(i=1;i<=NF;i++) if($i=="random:") print $(i+1)}' <<< "$status")
repeat_state=$(awk '/repeat:/ {for(i=1;i<=NF;i++) if($i=="repeat:") print $(i+1)}' <<< "$status")

# ---- Icons ----
[[ "$play_state" == "playing" ]] && play_icon="" || play_icon=""
[[ "$random_state" == "on" ]] && random_icon="" || random_icon=""
[[ "$repeat_state" == "on" ]] && repeat_icon="" || repeat_icon=""

# ---- Options ----
options="󰩈


$play_icon

$random_icon
$repeat_icon"

# ---- Header ----
header="$("$HOME/Documents/GitHub/.my-scripts/audio/mpc-np")"
#header="$("$HOME/.local/bin/statusbar/sb-music")"

choice=$(printf "%s\n" "$options" \
    | rofi -dmenu \
        -theme ~/.config/rofi/music.rasi \
        -mesg "$header")

# ---- Actions ----
case "$choice" in
    ""|"") mpc toggle ;;
    "") mpc next ;;
    "") mpc prev ;;
    "") mpc stop ;;
    ""|"")
        [[ "$random_state" == "on" ]] && { mpc random off; notify-send -i media-playlist-shuffle -t 1500 "🚫 shuffle disabled 🚫"; } || { mpc random on; notify-send -i media-playlist-shuffle -t 1500 "🔀 shuffle enabled 🔀"; }
        ;;
    ""|"")
        [[ "$repeat_state" == "on" ]] && { mpc repeat off; notify-send -i media-playlist-repeat -t 1500 "🚫 repeat disabled 🚫"; } || { mpc repeat on; notify-send -i media-playlist-repeat -t 1500 "🔁 repeat enabled 🔁"; }
        ;;
    "󰩈") exit 0 ;;
esac
