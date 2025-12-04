#!/usr/bin/env bash

# Pick your IWAD
#
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# DOOM HIGH RESOLUTION TEXURE PROJECT
#
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"

# BRUTAL DOOM
#
brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21-latest.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.16.0.pk3"

# MUSIC / SOUND
#
doom_metal_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
tourretes_guy_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"
live_reverb_path="$DOOMWADDIR/live-reverb/LiveReverb.pk3"

# HUD
#
#simplehudaddons_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Useful Tools - Minimods/simplehudaddons.pk3"
cats_visor_base_path="$DOOMWADDIR/cats-visor/catsvisorbase1.10.3.pk3"
cats_visor_path="$DOOMWADDIR/cats-visor/catsvisorc1.10.3_dynamic.pk3"

# GRAPHICS
#
voxel_path="$DOOMWADDIR/Voxel Doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"

# MISC
#
#glory_kill_path="$DOOMWADDIR/VanillaGloryKill/vanilla-glory-kill-master.pk3"


# SAVE FILE DIRECTORY
#
save_dir="$HOME/.config/uzdoom/savegames/brutal-doom-2"

# custom config location
config_path="$HOME/.config/uzdoom/configs/brutal-doom-2.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
#
for path in "$iwad_path" "$brutal_doom_path" "$doom_2016_music_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
#
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$rain_and_snow_path" "$dhtp_path" "$live_reverb_path" "$brutal_doom_path" "$doom_metal_path" "$tourretes_guy_path" -savedir "$save_dir" -config "$config_path"
