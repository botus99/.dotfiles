#!/usr/bin/env bash

# NOTE: If there are 2 or more paths with the same path name/label (i.e. Project Brutality) then the wads and pk3s are not compatitable with each other.

# Pick your IWAD
#iwad_path="$DOOMWADDIR/Doom (v1.9)/DOOM.WAD"
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"
#iwad_path="$DOOMWADDIR/Ultimate Doom, The (BFG Edition)/DOOM.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - The Plutonia Experiment (id Anthology)/PLUTONIA.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - Evilution (id Anthology)/TNT.WAD"

# BEAUTIFUL DOOM
beautiful_path="$DOOMWADDIR/beautiful-doom/Beautiful_Doom_716.pk3"

# HOCUS POCUS
hocus_path="$DOOMWADDIR/hocus-pocus/HOCUS_08_Zandronum_Final.pk3"

# BRUTAL DOOM
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.14.0_dev.pk3"
brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# MUSIC
#doom_metal_v5_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol5_44100.wad"
#doom_metal_v6_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"

# GRAPHICS
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/hocus-pocus"

# custom config location
config_path="$HOME/.config/uzdoom/configs/hocus-pocus.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$dhtp_path" "$beautiful_path"  "$hocus_path" "$rain_and_snow_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom.appimage -iwad "$iwad_path" -file "$dhtp_path" "$beautiful_path"  "$hocus_path" "$rain_and_snow_path" -savedir "$save_dir" -config "$config_path"
