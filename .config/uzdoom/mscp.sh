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

# MICRO SLAUGHTER COMMUNITY PROJECT
mscp_path="$DOOMWADDIR/mscp/MSCP_v1a.wad"

# GRAPHICS
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/mscp"

# custom config location
config_path="$HOME/.config/uzdoom/configs/mscp.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$dhtp_path" "$beautiful_path" "$rain_and_snow_path" "$mscp_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom.appimage -iwad "$iwad_path" -file "$dhtp_path" "$beautiful_path" "$rain_and_snow_path" "$mscp_path" -savedir "$save_dir" -config "$config_path"
