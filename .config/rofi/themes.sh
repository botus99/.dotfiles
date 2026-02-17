#!/usr/bin/env bash

AFTER_SCRIPT="$HOME/.config/wal/wal-after"

declare -A THEMES=(
    ["black-metal"]="base16-black-metal"
	["brogrammer"]="brogrammer"
	["brushtrees"]="base16-brushtrees"
    ["catppuccin macchiato"]="catppuccin-macchiato"
	["chicago"]="chicago"
    ["codeschool"]="base16-codeschool"
    ["darktooth"]="base16tooth"
    ["dawn"]="sexy-dawn"
	["deafened"]="sexy-deafened"
	["default"]="base16-default"
    ["doomicideocean"]="sexy-doomicideocean"
    ["dracula"]="dracula"
	["embers"]="base16-embers"
    ["forst"]="forst"
    ["everforest"]="everforest"
    ["gnome"]="sexy-gnometerm"
    ["google"]="base16-google"
	["gotham"]="sexy-gotham"
	["greenscreen"]="base16-greenscreen"
    ["gruvbox"]="gruvbox"
    ["gruvboxh"]="base16-gruvbox-hard"
    ["gruvboxm"]="base16-gruvbox-medium"
    ["gruvboxs"]="base16-gruvbox-soft"
	["harmonic"]="base16-harmonic"
	["insignificato"]="sexy-insignificato"
	["jasonwryan"]="sexy-jasonwryan"
    ["kanagawa"]="kanagawa"
    ["macintosh"]="base16-macintosh"
    ["material"]="hybrid-material"
	["mellow-purple"]="base16-mellow-purple"
	["nature-suede"]="sexy-gslob-nature-suede"
    ["nord"]="nord"
    ["one dark"]="base16-onedark"
	["orangish"]="sexy-orangish"
	["parker_brothers"]="sexy-parker_brothers"
	["phd"]="base16-phd"
    ["rosé pine"]="rose-pine-moon"
    ["solarized"]="solarized"
	["spacemacs"]="base16-spacemacs"
    ["swayr"]="sexy-swayr"
	["tango"]="sexy-tango"
	["terafox"]="terafox"
    ["tokyo night"]="tokyonight-moon"
    ["trim-yer-beard"]="sexy-trim-yer-beard"
	["tube"]="base16-tube"
	["victory"]="victory"
	["view"]="view"
    ["vscode"]="vscode"
   	["zenburn"]="sexy-zenburn"
)

CHOICE=$(printf "%s\n" "${!THEMES[@]}" \
    | sort \
    | rofi -dmenu \
           -theme ~/.config/rofi/themes.rasi \
           -p "")

[[ -z "$CHOICE" ]] && exit 0

THEME_NAME="${THEMES[$CHOICE]}"

#notify-send "applying theme" "$choice"

wal --theme "$THEME_NAME" -o "$AFTER_SCRIPT"
