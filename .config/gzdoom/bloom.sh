#!/usr/bin/env bash

# Pick your IWAD
#
iwad_path="$HOME/.wads/Doom II - Hell on Earth (BFG Edition)/DOOM2.WAD"

# BLOOM
#
bloom_path="$HOME/.wads/bloom/Bloom.pk3"

# GOLDENEYE
#
goldeneye_path="$HOME/.wads/goldeneye/GoldenEyeTC-Upgraded-NoTanks.pk3"
ge1="$HOME/.wads/goldeneye/Goldeneye-Complete.pk3"
ge2="$HOME/.wads/goldeneye/TWINE64Mini.pk3"

# BRUTAL DOOM
#
#brutal_doom_path="$HOME/.wads/brutalv21/brutalv21.14.0_dev.pk3"
#brutal_doom_path="$HOME/.wads/brutalv22/brutalv22test3.7a.pk3"
brutal_doom_path="$HOME/.wads/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# SIMPSONS
#
simpsons_path="$HOME/.wads/ulsimpdm/ulsimpdm.wad"

# MUSIC
#
#doom_metal_path="$HOME/.wads/DoomMetalVol5/DoomMetalVol5_44100.wad"
doom_2016_music_path="$HOME/.wads/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"

# SOUND
#
tourretes_guy_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"

# HUD
#
#simplehudaddons_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Useful Tools - Minimods/simplehudaddons.pk3"
cats_visor_base_path="$HOME/.wads/cats-visor/catsvisorbase1.10.3.pk3"
cats_visor_path="$HOME/.wads/cats-visor/catsvisorc1.10.3_dynamic.pk3"

# GRAPHICS
#
voxel_path="$HOME/.wads/Voxel Doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$HOME/.wads/rain-and-snow/Universal Rain and Snow v3.pk3"

# MISC
#
#glory_kill_path="$HOME/.wads/VanillaGloryKill/vanilla-glory-kill-master.pk3"


# SAVE FILE DIRECTORY
#
save_dir="$HOME/.config/gzdoom/savegames/bloom"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
#
for path in "$iwad_path" "$brutal_doom_path" "$doom_2016_music_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch GZDoom with custom commands
#
gzdoom -iwad "$iwad_path" -file "$bloom_path" -savedir "$save_dir"