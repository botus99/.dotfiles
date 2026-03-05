#!/usr/bin/env bash
# --------------------------------------------
# Original Author : Aditya Shakya (adi1090x)
# Tweaked by : botus99
# --------------------------------------------

# current theme
dir="$HOME/.config/rofi"
theme='power-menu'

# get session info
sessionstart="$(date -d "$(who -u | awk '{print $3, $4}')" +"%A  %-I:%M %P")"

# uptime and host
uptime="$(uptime -p)"
uptime="${uptime#up }"
host="${HOSTNAME:-$(hostname)}"

# icons
hibernate=''
shutdown='󰤆'
reboot='󰜉'
lock=''
suspend=''
logout='󰍃'
yes='󰄬'
no='󰯇'

rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg " Session: $sessionstart |  Uptime: $uptime" \
		-theme "${dir}"/${theme}.rasi
}

confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 320px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'you sure?' \
		-theme "${dir}"/${theme}.rasi
}

confirm_exit() {
	printf "%s\n%s\n" "$yes" "$no" | confirm_cmd
}

logout_session() {
    pkill -TERM -u "$USER"
}

run_cmd() {
    [[ "$(confirm_exit)" != "$yes" ]] && exit 0

    case "$1" in
        --shutdown) systemctl poweroff ;;
        --reboot) systemctl reboot ;;
        --hibernate) systemctl hibernate ;;
        --suspend)
            command -v mpc >/dev/null 2>&1 && mpc -q pause
            command -v wpctl >/dev/null 2>&1 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            systemctl suspend
            ;;
        --logout) logout_session ;;
    esac
}

# main menu
chosen="$(printf "%s\n%s\n%s\n%s\n%s\n%s\n" \
    "$lock" "$suspend" "$logout" "$hibernate" "$reboot" "$shutdown" | rofi_cmd)"

# exit if user presses escape
[[ -z "${chosen:-}" ]] && exit 0

# handle menu choice
case "$chosen" in
    $lock)
        if command -v slock >/dev/null 2>&1; then
            slock
        elif command -v betterlockscreen >/dev/null 2>&1; then
            betterlockscreen -l
        elif command -v i3lock >/dev/null 2>&1; then
            i3lock
        elif command -v swaylock >/dev/null 2>&1 && [[ -f "$HOME/.config/swaylock/config" ]]; then
            swaylock --config "$HOME/.config/swaylock/config"
        fi
        ;;
    $suspend) run_cmd --suspend ;;
    $logout) run_cmd --logout ;;
    $hibernate) run_cmd --hibernate ;;
    $reboot) run_cmd --reboot ;;
    $shutdown) run_cmd --shutdown ;;
esac
