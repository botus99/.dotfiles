#!/usr/bin/env bash

# Pick your IWAD
#
iwad_path="$HOME/.wads/Doom (v1.9)/DOOM.WAD"

# BRUTAL DOOM
#
#brutal_doom_path="$HOME/.wads/brutalv21/brutalv21.14.0_dev.pk3"
#brutal_doom_path="$HOME/.wads/brutalv22/brutalv22test3.7a.pk3"
brutal_doom_path="$HOME/.wads/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# SIMPSONS
#
simpsons_path="$HOME/.wads/ulsimpdm/ulsimpdm.wad"

# MUSIC
#doom_metal_v5_path="$HOME/.wads/music/doom-metal/DoomMetalVol5_44100.wad"
doom_metal_v6_path="$HOME/.wads/music/doom-metal/DoomMetalVol6.wad"
#doom_2016_music_path="$HOME/.wads/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"

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
save_dir="$HOME/.config/gzdoom/savegames/brutal-simpsons-doom"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
#
for path in "$iwad_path" "$brutal_doom_path" "$doom_metal_v6_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch GZDoom with custom commands
#
gzdoom -iwad "$iwad_path" -file "$brutal_doom_path" "$simpsons_path" "$doom_metal_v6_path" "$tourretes_guy_path" "$rain_and_snow_path" -savedir "$save_dir"
