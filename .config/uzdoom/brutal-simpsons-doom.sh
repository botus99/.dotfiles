#!/usr/bin/env bash

# Pick your IWAD
iwad_path="$DOOMWADDIR/Doom (v1.9)/DOOM.WAD"

# BRUTAL DOOM
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.14.0_dev.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# SIMPSONS
simpsons_path="$DOOMWADDIR/ulsimpdm/ulsimpdm.wad"

# MUSIC / SOUND
#doom_metal_v5_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol5_44100.wad"
doom_metal_v6_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
tourretes_guy_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"
live_reverb_path="$DOOMWADDIR/live-reverb/LiveReverb.pk3"

# GRAPHICS
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/brutal-simpsons-doom"

# custom config location
config_path="$HOME/.config/uzdoom/configs/brutal-simpsons-doom.ini"

# Check if required files exist
for path in "$iwad_path" "$brutal_doom_path" "$simpsons_path" "$live_reverb_path" "$tourretes_guy_path" "$rain_and_snow_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$brutal_doom_path" "$simpsons_path" "$live_reverb_path" "$tourretes_guy_path" "$rain_and_snow_path" -savedir "$save_dir" -config "$config_path"
