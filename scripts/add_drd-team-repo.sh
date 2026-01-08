#!/usr/bin/env bash

sudo wget -P /etc/apt/sources.list.d "https://debian.drdteam.org/drdteam-$(dpkg --print-architecture).sources"
sudo apt-get update
