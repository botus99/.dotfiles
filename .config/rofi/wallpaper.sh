#!/usr/bin/env bash
#  ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
#  ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#  ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
#  ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
#  ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
#   ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
#
#  ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#	originally written by : gh0stzk - https://github.com/gh0stzk/dotfiles
#	rewritten for hyprland by : develcooking - https://github.com/develcooking/hyprland-dotfiles
#	rewritten to use feh by : botus99 - https://github.com/botus99/.dotfiles
#	Info    - This script runs the rofi launcher, to select a wallpaper
#             from the directory that you can set below (wall_dir).

# Set some variables
wall_dir="${HOME}/.wallpapers"
cache_dir="${HOME}/.cache/wp"
rofi_command="rofi -x11 -dmenu -theme ${HOME}/.config/rofi/wallpaper.rasi -theme-str"

# Create cache dir if not exists
if [ ! -d "${cache_dir}" ] ; then
        mkdir -p "${cache_dir}"
    fi

#physical_monitor_size=47
#monitor_res=$(hyprctl monitors |grep -A2 Monitor |head -n 2 |awk '{print $1}' | grep -oE '^[0-9]+')
#monitor_res=$(xdpyinfo | grep dimensions | awk '{print $2}')
#dotsperinch=$(echo "scale=2; $monitor_res / $physical_monitor_size" | bc | xargs printf "%.0f")
#monitor=$(( $monitor_res "* $physical_monitor_size / $dotsperinch" ))
#rofi_override="element-icon{size:${monitor}px;border-radius:15px;}"

# Convert images in directory and save to cache dir
for image in "$wall_dir"/*.{jpg,jpeg,png,webp}; do
	if [ -f "$image" ]; then
		archive_number=$(basename "$image")
			if [ ! -f "${cache_dir}/${archive_number}" ] ; then
				convert -strip "$image" -thumbnail 480x270^ -gravity center -extent 480x270 "${cache_dir}/${archive_number}"
			fi
    fi
done

# Select a picture with rofi
wall_selection=$(find "${wall_dir}"  -maxdepth 1  -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | while read -r A ; do  echo -en "$A\x00icon\x1f""${cache_dir}"/"$A\n" ; done | $rofi_command)

# Set the wallpaper
[[ -n "$wall_selection" ]] || exit 1
feh --bg-fill "${wall_dir}"/"${wall_selection}"

exit 0
