#!/usr/bin/env bash

# Pick your IWAD
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# ADVENTURES OF SQUARE
square_path="$DOOMWADDIR/square-ep2-pk3-2.1/square1.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/adventure-of-square"

# custom config location
config_path="$HOME/.config/uzdoom/configs/adventure-of-square.ini"

# Check if required files exist
for path in "$iwad_path" "$square_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom.appimage -iwad "$iwad_path" -file "$square_path" -savedir "$save_dir" -config "$config_path"
