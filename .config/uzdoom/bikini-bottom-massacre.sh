#!/usr/bin/env bash

# Pick your IWAD
#
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# BRUTAL DOOM
#
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.16.0.pk3"
brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# SPONGEBOB
#
bikini_bottom_massacre_path="$DOOMWADDIR/bikini-bottom-massacre/bikini_bottom_massacre_(1.3).wad"

# MUSIC / SOUND
#
#doom_metal_path="$DOOMWADDIR/DoomMetalVol5/DoomMetalVol5_44100.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
tourretes_guy_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"

# GRAPHICS
#
voxel_path="$DOOMWADDIR/Voxel Doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"

# MISC
#
#glory_kill_path="$DOOMWADDIR/VanillaGloryKill/vanilla-glory-kill-master.pk3"

# SAVE FILE DIRECTORY
#
save_dir="$HOME/.config/uzdoom/savegames/bikini-bottom-massacre"

# custom config location
#
config_path="$HOME/.config/uzdoom/configs/bikini-bottom-massacre.ini"

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
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$bikini_bottom_massacre_path" -savedir "$save_dir" -config "$config_path"
