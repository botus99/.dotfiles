#!/usr/bin/env bash

# Pick your IWAD
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (BFG Edition)/DOOM2.WAD"

# BLOOM
bloom_path="$DOOMWADDIR/bloom/Bloom.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/bloom"

# custom config location
config_path="$HOME/.config/uzdoom/configs/bloom.ini"

# Check if required files exist
for path in "$iwad_path" "$bloom_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom.appimage -iwad "$iwad_path" -file "$bloom_path" -savedir "$save_dir" -config "$config_path"
