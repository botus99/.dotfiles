#!/usr/bin/env bash

# NOTE: If there are 2 or more paths with the same path name/label (i.e. Project Brutality) then the wads and pk3s are not compatitable with each other.

# Pick your IWAD
#iwad_path="$HOME/.wads/Doom (v1.9)/DOOM.WAD"
iwad_path="$HOME/.wads/Doom II - Hell on Earth (v1.9)/DOOM2.WAD"
#iwad_path="$HOME/.wads/Ultimate Doom, The (BFG Edition)/DOOM.WAD"
#iwad_path="$HOME/.wads/Final Doom - The Plutonia Experiment (id Anthology)/PLUTONIA.WAD"
#iwad_path="$HOME/.wads/Final Doom - Evilution (id Anthology)/TNT.WAD"

# GZDOOM OPTIONS (not nessesary if you have them load automatically, but here for testing purposes)
brightmaps_path="$HOME/.config/gzdoom/brightmaps.pk3"
widescreen_path="$HOME/.config/gzdoom/game_widescreen_gfx.pk3"
lights_path="$HOME/.config/gzdoom/lights.pk3"

# AREA 51
area51_path="$HOME/.wads/area51/Area51.wad"

# BEAUTIFUL DOOM
beautiful_path="$HOME/.wads/beautiful-doom/Beautiful_Doom_716.pk3"

# BLOOM
bloom_path="$HOME/.wads/bloom/Bloom.pk3"

# COMPENDIUM
compendium_path="$HOME/.wads/compendium/Compendium-v1a.pk3"
compendium_path2="$HOME/.wads/compendium/compen-play.pk3"

# EVITERNITY
eviternity_path="$HOME/.wads/eviternity/Eviternity.wad"

# GOLDENEYE
goldeneye_path="$HOME/.wads/goldeneye/GoldenEyeTC-Upgraded-NoTanks.pk3"
ge1="$HOME/.wads/goldeneye/Goldeneye-Complete.pk3"
ge2="$HOME/.wads/goldeneye/TWINE64Mini.pk3"

# HOCUS POCUS
hocus_path="$HOME/.wads/hocus-pocus/HOCUS_08_Zandronum_Final.pk3"

# MICRO SLAUGHTER COMMUNITY PROJECT
mscp_path="$HOME/.wads/mscp/MSCP_v1a.wad"

# BRUTAL DOOM
#brutal_doom_path="$HOME/.wads/brutalv21/brutalv21.14.0_dev.pk3"
brutal_doom_path="$HOME/.wads/brutalv22/brutalv22beta3.5.pk3"
#brutal_doom_path="$HOME/.wads/brutalv21/weapons-only/brutal21_weapons_only_Zandronum_fix.pk3"

# PROJECT BRUTALITY
#project_brutality_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Various/Project Brutality Monsters Standalone.pk3"
#project_brutality_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Various/Glory_Kill_v25a.pk3"
#project_brutality_path="$HOME/.wads/Project Brutality Public Files/Community Addons/WADs/Eviternity.wad"
#project_brutality_path="$HOME/.wads/Project Brutality Public Files/Community Addons/WADs/Doom 2 TWID.wad"
#project_brutality_path="$HOME/.wads/Project Brutality Public Files/Project Brutality/project brutality 2.02.pk3"
#project_brutality_path="$HOME/.wads/project-brutality/Project_Brutality_27.04.24.pk3"

# KING OF THE HILL
hank_path="$HOME/.wads/hank-hill/hank.wad"

# SIMPSONS
simpsons_path="$HOME/.wads/ulsimpdm/ulsimpdm.wad"

# MUSIC
#doom_metal_v5_path="$HOME/.wads/music/doom-metal/DoomMetalVol5_44100.wad"
#doom_metal_v6_path="$HOME/.wads/music/doom-metal/DoomMetalVol6.wad"
doom_2016_music_path="$HOME/.wads/music/doom-2016/DOOMIIHellOnEarth_DOOMEternal_OST.pk3"
psx-doom-music="$HOME/.wads/music/psx-doom/PSXOstUltimateHQ.pk3"

# SOUND
tourretes_guy_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Various/Voice Add-ons/Tourretes Guy Offends PB.pk3"

# HUD
simplehudaddons_path="$HOME/.wads/Project Brutality Public Files/Community Addons/Useful Tools - Minimods/simplehudaddons.pk3"
cats_visor_base_path="$HOME/.wads/cats-visor/catsvisorbase1.10.3.pk3"
cats_visor_path="$HOME/.wads/cats-visor/catsvisorc1.10.3_dynamic.pk3"

# GRAPHICS
voxel_path="$HOME/.wads/voxel-doom/cheello_voxels_zan.pk3"
rain_and_snow_path="$HOME/.wads/rain-and-snow/Universal Rain and Snow v3.pk3"
dhtp_path="$HOME/.wads/dhtp/zdoom-dhtp-20180514.pk3"

# MISC
glory_kill_path="$HOME/.wads/vanilla-glory-kill/vanilla-glory-kill-master.pk3"

# DOOM 64
doom64_path="$HOME/.wads/doom-64-retribution/D64RTR[v1.5].WAD"

# PSX
psx_bgm="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.BGM.Extended.pk3"
psx_brightmaps="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Brightmaps.pk3"
psx_decals="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Decals.pk3"
psx_extra="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Extra.pk3"
psx_parallax="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.Parallax.pk3"
psx_pbr="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.GFX.PBR.pk3"
psx_sfx="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Addon.SFX.HQ.pk3"
psx_doom="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.ipk3"
psx_lost_levels="$HOME/.wads/psx-doom/PSXDOOM.CE-3.9.1/PSXDOOM.CE.Maps.LostLevels.pk3"

# BRUTAL PSX
brutal_psx="$HOME/.wads/psx-doom/psx_brutal_doom_v20b.pk3"

# SAVE FILE DIRECTORY
save_dir="$HOME/.config/gzdoom/savegames/brutal-doom-64"

# custom config locataion
config_path="$HOME/.config/gzdoom/configs/brutal-doom-64.ini"

# Check if required files exist
# ADD PATHS FROM ABOVE AS NEEDED
for path in "$iwad_path" "$dhtp_path" "$beautiful_path"  "$doom64_path" "$rain_and_snow_path" "$cats_visor_base_path" "$cats_visor_path"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found."
        exit 1
    fi
done


# Launch GZDoom with custom commands
gzdoom -iwad "$iwad_path" -file "$doom64_path" "$rain_and_snow_path" "$cats_visor_base_path" "$cats_visor_path" -savedir "$save_dir"
#gzdoom -iwad "$iwad_path" -file "$doom64_path" -savedir "$save_dir"
# -config "$config_path"	# use when a custom config makes sense
