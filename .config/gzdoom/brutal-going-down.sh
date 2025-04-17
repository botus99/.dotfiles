#!/usr/bin/env bash

# Add wads or pk3s paths
iwad_path="$HOME/.wads/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# GZDOOM OPTIONS (not nessesary if you have them load automatically, but here for testing purposes)
brightmaps_path="$HOME/.config/gzdoom/brightmaps.pk3"
widescreen_path="$HOME/.config/gzdoom/game_widescreen_gfx.pk3"
lights_path="$HOME/.config/gzdoom/lights.pk3"

# BEAUTIFUL DOOM
beautiful_path="$HOME/.wads/beautiful-doom/Beautiful_Doom_716.pk3"

# BRUTAL DOOM
#brutal_doom_path="$HOME/.wads/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"
brutal_doom_path="$HOME/.wads/brutalv21/brutalv21.16.0.pk3"

# MUSIC / SOUND
doom_metal_path="$HOME/.wads/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$HOME/.wads/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
tourretes_guy_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"
live_reverb_path="$HOME/.wads/live-reverb/LiveReverb.pk3"

# GRAPHICS
voxel_path="$HOME/.wads/voxel-doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$HOME/.wads/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$HOME/.wads/dhtp/zdoom-dhtp-20180514.pk3"

# MISC
glory_kill_path="$HOME/.wads/VanillaGloryKill/vanilla-glory-kill-master.pk3"
going_down_path="$HOME/.wads/gd/gd.wad"



save_dir="$HOME/.config/gzdoom/savegames/brutal-going-down"
config_path="$HOME/.config/gzdoom/configs/going-down.ini"

# Check if required files exist
for path in "$iwad_path" "$going_down_path" "$brutal_doom_path" "$doom_2016_music_path" "$tourretes_guy_path" "$rain_and_snow_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch GZDoom with custom commands
ENABLE_VKBASALT=1 gzdoom -iwad "$iwad_path" -file "$going_down_path" "$brutal_doom_path" "$doom_2016_music_path" "$tourretes_guy_path" "$rain_and_snow_path" -savedir "$save_dir" -config "$config_path"
