#!/usr/bin/env bash

ARGS="--volume=50"
TITLE="rofi-radio"
PID_FILE="/tmp/radio_pid"
IPC_SOCKET="/tmp/mpv_socket"

declare -A STATIONS=(
    ["❌ [STOP/KILL] ❌"]="stop_radio"
    ["🖥️ lofi girl"]="https://play.streamafrica.net/lofiradio"
    ["🖥️ chillhop"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
    ["🖥️ box lofi"]="http://stream.zeno.fm/f3wvbbqmdg8uv"
    ["📻️ the bootleg boy"]="http://stream.zeno.fm/0r0xa792kwzuv"
    ["📻️ radio spinner"]="https://live.radiospinner.com/lofi-hip-hop-64"
    ["🎷 smooth chill"]="https://media-ssl.musicradio.com/SmoothChill"
    ["🏛️ wcpt 820"]="https://26183.live.streamtheworld.com/WCPTAM.mp3"
    ["🤾 wscr 670"]="https://prod-44-192-113-78.amperwave.net/audacy-wscramaac-imc"
    ["🤾 wmvp 1000"]="https://prod-54-242-39-29.amperwave.net/goodkarma-wmvpammp3-ibc1"
    ["📢 npr"]="http://npr-ice.streamguys1.com/live.mp3"
    ["🪩 classic vinyl hd"]="https://icecast.walmradio.com:8443/classic_opus"
    ["📻️ old time radio"]="https://icecast.walmradio.com:8443/otr_opus"
    ["🧈 smooth jazz"]="http://www.101smoothjazz.com/101-smoothjazz.m3u"
    ["💊 ambient sleeping pill"]="http://radio.stereoscenic.com/asp-h"
    ["🥗 groove salad"]="https://somafm.com/groovesalad.pls"
    ["🎻 classical relax"]="http://relax.stream.publicradio.org/relax.mp3"
    ["🎻 greatest classical"]="https://az1.mediacp.eu/listen/100greatestclassicalmusic/radio.mp3"
    ["🌧️ rain relax "]="https://maggie.torontocast.com:2020/stream/natureradiorain"
    ["🌳 nature relax"]="https://0nlineradio.radioho.st/lounge-nature-sounds?ref=radio-browser26"
    ["🌲 pure nature"]="https://purenature-mynoise.radioca.st/stream"
    ["💤 music for sleep"]="https://0nlineradio.radioho.st/classical-classical-music-for-sleep?ref=radio-browser26"
	["🤘 rockantenne"]="http://mp3channels.webradio.rockantenne.de/heavy-metal"
	["🤘 bandit metal"]="https://wr03-ice.stream.khz.se/wr03_mp3"
	["🤘 metalrock.fm"]="https://kathy.torontocast.com:2800/;"
)

notification() {
    notify-send "rofi radio" "$1" --icon=media-tape -t 3000
}

kill_radio_silent() {
    if [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
        [[ -S "$IPC_SOCKET" ]] && rm -f "$IPC_SOCKET"
    fi
}

stop_radio() {
    if [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
        [[ -S "$IPC_SOCKET" ]] && rm -f "$IPC_SOCKET"
        notification "radio stopped"
    else
        notification "no radio playing."
    fi
}

main() {
    choice=$(printf "%s\n" "${!STATIONS[@]}" \
        | sort \
        | rofi -dmenu \
               -theme ~/.config/rofi/radio.rasi \
               -p "")

    # if user cancels → do nothing
    [[ -z "$choice" ]] && exit 0

    target="${STATIONS[$choice]}"

    if [[ "$target" == "stop_radio" ]]; then
        stop_radio
        exit 0
    fi

    # silently kill any radio playing
    kill_radio_silent

    # show off your choice
    notification "$choice"

    # launch radio station in the background
    mpv --title="$TITLE" --input-ipc-server="$IPC_SOCKET" $ARGS "$target" &

    # save PID of mpv process
    echo $! > "$PID_FILE"
}

main
