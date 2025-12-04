#!/usr/bin/env bash

# Pick your IWAD
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"

# SPONGEBOB
bikini_bottom_massacre_path="$DOOMWADDIR/bikini-bottom-massacre/bikini_bottom_massacre_(1.3).wad"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/bikini-bottom-massacre"

# custom config location
config_path="$HOME/.config/uzdoom/configs/bikini-bottom-massacre.ini"

# Check if required files exist
for path in "$iwad_path" "$bikini_bottom_massacre_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom.appimage -iwad "$iwad_path" -file "$bikini_bottom_massacre_path" -savedir "$save_dir" -config "$config_path"
