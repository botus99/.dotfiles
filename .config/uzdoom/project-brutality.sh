#!/usr/bin/env bash

# NOTE: If there are 2 or more paths with the same path name/label (i.e. Project Brutality) then the wads and pk3s are not compatitable with each other... sometimes

# Pick your IWAD
#iwad_path="$DOOMWADDIR/Doom (v1.9)/DOOM.WAD"
iwad_path="$DOOMWADDIR/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"
#iwad_path="$DOOMWADDIR/Ultimate Doom, The (BFG Edition)/DOOM.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - The Plutonia Experiment (id Anthology)/PLUTONIA.WAD"
#iwad_path="$DOOMWADDIR/Final Doom - Evilution (id Anthology)/TNT.WAD"


# UZDOOM OPTIONS (not nessesary if you have them load automatically, but here for testing purposes)
brightmaps_path="$HOME/.config/uzdoom/brightmaps.pk3"
widescreen_path="$HOME/.config/uzdoom/game_widescreen_gfx.pk3"
lights_path="$HOME/.config/uzdoom/lights.pk3"

# BEAUTIFUL DOOM
beautiful_path="$DOOMWADDIR/beautiful-doom/Beautiful_Doom_716.pk3"

# BLOOM
bloom_path="$DOOMWADDIR/bloom/Bloom.pk3"


# GOLDENEYE
goldeneye_path="$DOOMWADDIR/goldeneye/GoldenEyeTC-Upgraded-NoTanks.pk3"
ge1="$DOOMWADDIR/goldeneye/Goldeneye-Complete.pk3"
ge2="$DOOMWADDIR/goldeneye/TWINE64Mini.pk3"


# BRUTAL DOOM
brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.15.3_dev.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"


# PROJECT BRUTALITY
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Project Brutality Monsters Standalone.pk3"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Glory_Kill_v25a.pk3"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/WADs/Eviternity.wad"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/WADs/Doom 2 TWID.wad"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Project Brutality/project brutality 2.02.pk3"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Project Brutality/project brutality 2.0.pk3"
project_brutality_path="$DOOMWADDIR/project-brutality/Project_Brutality_2024-10-05.pk3"


# SIMPSONS
simpsons_path="$DOOMWADDIR/ulsimpdm/ulsimpdm.wad"


# MUSIC
#doom_metal_v5_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol5_44100.wad"
#doom_metal_v6_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"


# SOUND
tourretes_guy_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"


# HUD
simplehudaddons_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Useful Tools - Minimods/simplehudaddons.pk3"
cats_visor_base_path="$DOOMWADDIR/cats-visor/catsvisorbase1.10.3.pk3"
cats_visor_path="$DOOMWADDIR/cats-visor/catsvisorc1.10.3_dynamic.pk3"


# GRAPHICS
voxel_path="$DOOMWADDIR/Voxel Doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"


# MISC
glory_kill_path="$DOOMWADDIR/VanillaGloryKill/vanilla-glory-kill-master.pk3"


# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/project-brutality"


# custom config location
config_path="$HOME/.config/uzdoom/configs/project-brutality.ini"


# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$project_brutality_path" "$doom_2016_music_path" "$tourretes_guy_path" "$rain_and_snow_path" "$dhtp_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done


# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$beautiful_path" "$project_brutality_path" "$doom_2016_music_path" "$rain_and_snow_path" -savedir "$save_dir" -config "$config_path"
