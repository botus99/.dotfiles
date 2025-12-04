#!/usr/bin/env bash

# NOTE: If there are 2 or more paths with the same path name/label (i.e. Project Brutality) then the wads and pk3s are not compatitable with each other.

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

# BRUTAL DOOM
#brutal_doom_path="$DOOMWADDIR/brutalv21/brutalv21.14.0_dev.pk3"
#brutal_doom_path="$DOOMWADDIR/brutalv22/brutalv22test3.7a.pk3"
brutal_doom_path="$DOOMWADDIR/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# PROJECT BRUTALITY
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Project Brutality Monsters Standalone.pk3"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Glory_Kill_v25a.pk3"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/WADs/Eviternity.wad"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/WADs/Doom 2 TWID.wad"
#project_brutality_path="$DOOMWADDIR/Project Brutality Public Files/Project Brutality/project brutality 2.02.pk3"
#project_brutality_path="$DOOMWADDIR/project-brutality/Project_Brutality_27.04.24.pk3"

# MUSIC
#doom_metal_v5_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol5_44100.wad"
#doom_metal_v6_path="$DOOMWADDIR/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$DOOMWADDIR/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
psx-doom-music="$DOOMWADDIR/music/psx-doom/PSXOstUltimateHQ.pk3"

# SOUND
tourretes_guy_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"

# HUD
simplehudaddons_path="$DOOMWADDIR/Project Brutality Public Files/Community Addons/Useful Tools - Minimods/simplehudaddons.pk3"

# GRAPHICS
voxel_path="$DOOMWADDIR/voxel-doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$DOOMWADDIR/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$DOOMWADDIR/dhtp/zdoom-dhtp-20180514.pk3"

# MISC
glory_kill_path="$DOOMWADDIR/vanilla-glory-kill/vanilla-glory-kill-master.pk3"

# PSX
psx_bgm="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.BGM.Extended.pk3"
psx_brightmaps="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Brightmaps.pk3"
psx_decals="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Decals.pk3"
psx_extra="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Extra.pk3"
psx_parallax="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Parallax.pk3"
psx_pbr="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.PBR.pk3"
psx_sfx="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.SFX.HQ.pk3"
psx_doom="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.ipk3"
psx_lost_levels="$DOOMWADDIR/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Maps.LostLevels.pk3"

# BRUTAL PSX
brutal_psx="$DOOMWADDIR/psx-doom/psx_brutal_doom_v20b.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/uzdoom/savegames/brutal-psx/"

# custom config location
config_path="$HOME/.config/uzdoom/configs/brutal-psx.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$dhtp_path" "$beautiful_path"  "$brutal_doom_path" "$tourretes_guy_path" "$rain_and_snow_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done

# Launch UZDoom with custom commands
ENABLE_VKBASALT=1 uzdoom -iwad "$iwad_path" -file "$brutal_psx" "$tourretes_guy_path" "$rain_and_snow_path" "$psx_bgm" -savedir "$save_dir" -config "$config_path"
