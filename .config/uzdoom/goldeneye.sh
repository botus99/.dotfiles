#!/usr/bin/env bash

# Pick your IWAD
#iwad_path="$DOOMWADDIR/Doom (v1.9)/DOOM.WAD"
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# GOLDENEYE
goldeneye_path="$DOOMWADDIR/goldeneye/GoldenEyeTC-Upgraded-NoTanks.pk3"
ge1="$DOOMWADDIR/goldeneye/Goldeneye-Complete.pk3"
ge2="$DOOMWADDIR/goldeneye/TWINE64Mini.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/goldeneye"

# Check if required files exist
for path in "$iwad_path" "$goldeneye_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$goldeneye_path" -savedir "$save_dir"
