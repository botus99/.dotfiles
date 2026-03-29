#!/usr/bin/env bash

set -euo pipefail

#################################
# Config
#################################

DEFAULT_DIR="${HOME}/Videos"
JOBS="${JOBS:-$(nproc)}"
NORMALIZE_AUDIO_BATCH=""

#################################
# Dependency Check
#################################

for cmd in ffmpeg ffprobe rofi parallel notify-send; do
    command -v "$cmd" >/dev/null || {
        echo "Missing dependency: $cmd"
        exit 1
    }
done

#################################
# Hardware Auto Detection
#################################

detect_encoder() {
    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q hevc_nvenc; then
        echo "hevc_nvenc"
    elif ffmpeg -hide_banner -encoders 2>/dev/null | grep -q hevc_vaapi; then
        echo "hevc_vaapi"
    else
        echo "libx265"
    fi
}

#################################
# Rofi Helpers
#################################

rofi_menu() { rofi -dmenu -theme "~/.config/rofi/media-toolkit.rasi" -p "$1"; }
notify() { notify-send "Media Toolkit" "$1"; }

#################################
# File Collection
#################################

collect_files() {
    mapfile -d '' FILES < <(
        find "$1" -type f \( \
            -iname "*.wmv" -o \
            -iname "*.avi" -o \
            -iname "*.mpg" -o \
            -iname "*.mpeg" -o \
            -iname "*.mkv" -o \
            -iname "*.mp4" -o \
            -iname "*.m4v" -o \
            -iname "*.flv" -o \
            -iname "*.mov" -o \
            -iname "*.webm" \
        \) -print0
    )
}

#################################
# Operations
#################################

remove_subs() {
    local file="$1"
    local output="${file%.*}--no-subs.mkv"

    ffmpeg -hide_banner -loglevel error \
        -i "$file" \
        -map 0 -map -0:s \
        -map_metadata 0 \
        -c copy \
        -movflags +faststart \
        "$output"

    [[ "$REPLACE" == "yes" ]] && mv -f "$output" "$file"
}

extract_subs() {
    local file="$1"
    local base="${file%.*}"

    mapfile -t streams < <(
        ffprobe -v error -select_streams s \
        -show_entries stream=index \
        -of csv=p=0 "$file"
    )

    for s in "${streams[@]}"; do
        ffmpeg -hide_banner -loglevel error \
            -i "$file" -map 0:s:"$s" \
            "$base.sub$s.srt"
    done
}

convert_container() {
    local file="$1"
    local output="${file%.*}.$FORMAT"

    ffmpeg -hide_banner -loglevel error \
        -fflags +genpts \
        -i "$file" \
        -map 0 \
        -map_metadata 0 \
        -speed veryslow \
        -c copy \
        -avoid_negative_ts make_zero \
        -movflags +faststart \
        "$output"

    [[ "$REPLACE" == "yes" ]] && mv -f "$output" "$file"
}

normalize_audio() {
    local file="$1"
    local output="${file%.*}--normalized.mkv"

    ffmpeg -hide_banner -loglevel error \
        -fflags +genpts \
        -i "$file" \
        -map 0 \
        -map_metadata 0 \
        -speed veryslow \
        -c:v copy \
        -tune:v hq \
        -af loudnorm \
        -c:a "$AUDIO_CODEC" \
        -movflags +faststart \
        "$output"

    [[ "$REPLACE" == "yes" ]] && mv -f "$output" "$file"
}

reencode_auto() {
    local file="$1"
    local output="${file%.*}--h265.mkv"
    local encoder="$ENCODER"

    if [[ "$encoder" == "hevc_vaapi" ]]; then
        ffmpeg -hide_banner -loglevel error \
            -fflags +genpts \
            -vaapi_device /dev/dri/renderD128 \
            -i "$file" \
            -map 0 \
            -map_metadata 0 \
            -vf 'format=nv12,hwupload' \
            -speed veryslow \
            -c:v hevc_vaapi -qp 27 \
            -tune:v hq \
            -c:a "$AUDIO_CODEC" \
            -movflags +faststart \
            "$output"
    elif [[ "$encoder" == "hevc_nvenc" ]]; then
        ffmpeg -hide_banner -loglevel error \
            -fflags +genpts \
            -i "$file" \
            -map 0 \
            -map_metadata 0 \
            -speed veryslow \
            -c:v hevc_nvenc -preset p7 -cq 27 \
            -tune:v hq \
            -pix_fmt p010le \
            -gpu any \
            -profile:v main10 \
            -c:a "$AUDIO_CODEC" \
            -movflags +faststart \
            "$output"
    else
        ffmpeg -hide_banner -loglevel error \
            -fflags +genpts \
            -i "$file" \
            -map 0 \
            -map_metadata 0 \
            -speed veryslow \
            -c:v libx265 -crf 27 \
            -tune:v hq \
            -c:a "$AUDIO_CODEC" \
            -movflags +faststart \
            "$output"
    fi

    [[ "$REPLACE" == "yes" ]] && mv -f "$output" "$file"
}

choose_audio_normalization() {
    NORMALIZE_AUDIO_BATCH=$(printf "Yes\nNo" \
        | rofi -dmenu -p "Normalize audio for all files?" \
               -theme ~/.config/rofi/radio.rasi)
    
    # Default to No if user cancels
    [[ -z "$NORMALIZE_AUDIO_BATCH" ]] && NORMALIZE_AUDIO_BATCH="No"
}

choose_deinterlace_mode() {
    DEINT_MODE=$(printf "%s\n" \
        "Auto (YADIF)" \
        "TFF (Top Field First)" \
        "BFF (Bottom Field First)" \
        "De-telecine (IVTC)" \
        "De-telecine + Dejudder" \
        "Dejudder Only" \
        "None" \
        | rofi_menu "Deinterlace / Telecine Mode")

    [[ -z "$DEINT_MODE" ]] && DEINT_MODE="None"
}

build_video_filter() {

    local filters=()

    case "$DEINT_MODE" in
        "Auto (YADIF)")
            filters+=("yadif=1")
            ;;
        "TFF (Top Field First)")
            filters+=("yadif=1:0")
            ;;
        "BFF (Bottom Field First)")
            filters+=("yadif=1:1")
            ;;
        "De-telecine (IVTC)")
            filters+=("fieldmatch")
            filters+=("decimate")
            ;;
        "De-telecine + Dejudder")
            filters+=("fieldmatch")
            filters+=("decimate")
            filters+=("dejudder")
            ;;
        "Dejudder Only")
            filters+=("dejudder")
            ;;
        "None")
            ;;
    esac

    filters+=("fps=${TARGET_FPS}")

    local IFS=,
    echo "${filters[*]}"
}

reencode_fps() {
    local file="$1"
    local output="${file%.*}--x265-${TARGET_FPS}fps.mkv"

    # Audio filter
    if [[ "$NORMALIZE_AUDIO_BATCH" == "Yes" ]]; then
        AUDIO_FILTER="loudnorm=I=-16:TP=-1.5:LRA=11"
    else
        AUDIO_FILTER="anull"
    fi

    local VIDEO_FILTER
    VIDEO_FILTER=$(build_video_filter)

    ffmpeg -hide_banner -loglevel error \
        -fflags +genpts \
        -i "$file" \
        -map 0 \
        -map_metadata 0 \
        -c:a "$AUDIO_CODEC" \
        -af "$AUDIO_FILTER" \
        -c:v hevc_nvenc -preset p7 -cq 27 \
        -pix_fmt p010le \
        -profile:v main10 \
        -gpu any \
        -vf "$VIDEO_FILTER" \
        -avoid_negative_ts make_zero \
        -movflags +faststart \
        "$output"

    [[ "$REPLACE" == "yes" && -f "$output" ]] && mv -f "$output" "$file"
}

#################################
# Parallel Runner
#################################

run_parallel() {
    export -f remove_subs extract_subs convert_container \
        normalize_audio reencode_auto reencode_fps \
        build_video_filter
    export REPLACE FORMAT AUDIO_CODEC ENCODER TARGET_FPS \
        NORMALIZE_AUDIO_BATCH DEINT_MODE

    printf "%s\0" "${FILES[@]}" |
        parallel -0 -j "$JOBS" --bar "$ACTION" {}
}

#################################
# Main
#################################

main() {
	ACTION=$(printf "%s\n" \
    	"Remove Subtitles (keep all streams except subs)" \
    	"Extract Subtitles (export all subtitle tracks)" \
    	"Convert Container (remux without re-encoding)" \
    	"Normalize Audio (loudness normalization only)" \
    	"Re-encode → H.265 (Auto Hardware, no FPS change)" \
    	"Re-encode → H.265 + FPS Convert + Deinterlace / IVTC / Dejudder" \
	    | rofi_menu "Media Toolkit")


    [[ -z "$ACTION" ]] && exit 0

    # Validate default directory
    BASE_DIR="$DEFAULT_DIR"
    [[ -d "$BASE_DIR" ]] || BASE_DIR="$HOME"
    
    DIR=$(find "$BASE_DIR" -type d 2>/dev/null | rofi_menu "Select directory")
        [[ -z "$DIR" ]] && exit 0

    collect_files "$DIR"
    [[ "${#FILES[@]}" -eq 0 ]] && { notify "No files found."; exit 0; }

    REPLACE=$(printf "no\nyes\n" | rofi_menu "Replace originals?")
    [[ -z "$REPLACE" ]] && exit 0

    AUDIO_CODEC=$(printf "copy\naac\nopus\nac3\n" | rofi_menu "Audio codec")
    [[ -z "$AUDIO_CODEC" ]] && exit 0

    case "$ACTION" in
        "Remove Subtitles (keep all streams except subs)") ACTION=remove_subs ;;
        "Extract Subtitles (export all subtitle tracks)") ACTION=extract_subs ;;
        "Convert Container (remux without re-encoding)")
            FORMAT=$(printf "mkv\nmp4\n" | rofi_menu "Target format")
            [[ -z "$FORMAT" ]] && exit 0
            ACTION=convert_container
            ;;
        "Normalize Audio (loudness normalization only)")
            ACTION=normalize_audio
            ;;
    	"Re-encode → H.265 (Auto Hardware, no FPS change)")
            ENCODER=$(detect_encoder)
            ACTION=reencode_auto
            ;;
    	"Re-encode → H.265 + FPS Convert + Deinterlace / IVTC / Dejudder")
        	TARGET_FPS=$(printf "%s\n" \
        	"23.976" "24" "25" "29.97" "30" \
        	"47.952" "48" "50" "59.94" "60" \
        	| rofi_menu "Select target FPS")
    		[[ -z "$TARGET_FPS" ]] && exit 0
    		choose_deinterlace_mode
    		choose_audio_normalization
    		ACTION=reencode_fps
    		;;
    esac

    notify "Processing ${#FILES[@]} file(s)..."
    run_parallel
    notify "Completed."
}

main
