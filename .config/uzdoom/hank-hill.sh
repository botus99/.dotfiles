#!/usr/bin/env bash

# NOTE: If there are 2 or more paths with the same path name/label (i.e. Project Brutality) then the wads and pk3s are not compatitable with each other.

# Pick your IWAD
#iwad_path="$DOOMWADDIR/Doom (v1.9)/DOOM.WAD"
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"
#iwad_path="$DOOMWADDIR/Ultimate Doom, The (BFG Edition)/DOOM.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - The Plutonia Experiment (id Anthology)/PLUTONIA.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - Evilution (id Anthology)/TNT.WAD"

# BRUTAL DOOM
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.14.0_dev.pk3"
brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# KING OF THE HILL
hank_path="$DOOMWADDIR/hank-hill/Hank.wad"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/hank-hill"

# custom config location
config_path="$HOME/.config/uzdoom/configs/hank-hill.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$hank_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$hank_path"  -savedir "$save_dir" -config "$config_path"
