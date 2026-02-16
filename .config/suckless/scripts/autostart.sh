#!/usr/bin/env bash

# =========================================================================== #
#                                    POLKIT                                   #
# =========================================================================== #

#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
pidof lxpolkit >/dev/null || lxpolkit &

# =========================================================================== #
#                                   DESKTOP                                   #
# =========================================================================== #

# status bar
#~/.config/polybar/my-forest/launch.sh &
#slstatus &
pidof dwmblocks >/dev/null || dwmblocks &

# wallpaper
~/.fehbg &

# macros
pgrep -x sxhkd >/dev/null || sxhkd -c ~/.config/suckless/sxhkd/sxhkdrc &

# notifications
pidof dunst >/dev/null || dunst -config ~/.config/suckless/dunst/dunstrc &

# compositor
pidof picom >/dev/null || picom --config ~/.config/suckless/picom/picom.conf -b &

# redshift
pidof redshift >/dev/null || redshift -P -l 41.76058:-88.32007 &

# =========================================================================== #
#                                STARTUP VIDEO                                #
# =========================================================================== #

#STARTUPVID="$HOME/.config/autostart/turning-me-on.mkv"
#/usr/bin/kitty --start-as fullscreen bash -c "/usr/bin/mpv --really-quiet -vo tct --ontop --ontop-level=system --osd-level=0 --osc=no --fullscreen ${STARTUPVID}" &
#/usr/local/bin/st bash -c "/usr/bin/mpv --really-quiet -vo tct --ontop --ontop-level=system --osd-level=0 --osc=no --fullscreen ${STARTUPVID}" &
#/usr/bin/mpv --really-quiet -vo tct --ontop --ontop-level=system --osd-level=0 --osc=no --fullscreen ${STARTUPVID} &

# =========================================================================== #
#                             STARTUP APPLICATIONS                            #
# =========================================================================== #

# start android messages app
pidof AndroidMessages >/dev/null || "/opt/Android Messages/AndroidMessages" &

# still need to figure out how to enable it and not just load the indicator
pgrep -f caffeine-indicator >/dev/null || caffeine-indicator &
