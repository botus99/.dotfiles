#!/usr/bin/env bash
#
# This repo is for things related to the game Doom from the early 90s
# Good if you want deb installs of uzdoom, doomseeker, slade, zandronum, etc

sudo wget -P /etc/apt/sources.list.d "https://debian.drdteam.org/drdteam-$(dpkg --print-architecture).sources"
sudo apt-get update
