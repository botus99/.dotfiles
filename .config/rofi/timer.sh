#!/usr/bin/env bash
set -euo pipefail

ICON="/tmp/timericon"
PID="/tmp/timer.pid"
SIG="RTMIN+3"
SOUND="${HOME}/.local/share/sounds/alarm.oga"

update() { pkill -"$SIG" dwmblocks 2>/dev/null || true; }
cleanup() { rm -f "$PID"; echo "" > "$ICON"; update; exit 0; }

start() {
    local t=$1
    trap cleanup EXIT INT TERM
    echo $$ > "$PID"

    while (( t > 0 )); do
        printf -v m "%02d" $((t/60))
        printf -v s "%02d" $((t%60))
        printf "  󰔟 %s:%s" "$m" "$s" > "$ICON"
        update
        sleep 1
        ((t--))
    done

    notify-send -u critical "⏲ timer complete"
    command -v play >/dev/null && play --volume=67 "$SOUND" &
    cleanup
}

menu() {
    local min
    min=$(rofi -dmenu -theme ~/.config/rofi/timer.rasi -p "how many minutes d’ya need?")
    [[ "$min" =~ ^[0-9]+$ && "$min" -gt 0 ]] && start $((min*60))
}

stop() {
    [[ -f "$PID" ]] && kill -TERM "$(cat "$PID")" 2>/dev/null
}

case "${1:-}" in
    stop) stop ;;
    *) menu ;;
esac
