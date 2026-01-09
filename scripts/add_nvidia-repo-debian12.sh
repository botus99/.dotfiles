#!/usr/bin/env bash
#
# NVIDIA begins support for Debian 13 - Trixie with the 590 update
# The 590 update breaks support for some older cards
# This repo contains the latest driver for cards that can't run the 590 update

sudo apt-get install dirmngr ca-certificates software-properties-common apt-transport-https dkms curl -y
curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1

# old way
#echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

echo '
Types: deb
URIs: https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/
Suites: /
Components:
Signed-By: /usr/share/keyrings/nvidia-drivers.gpg
' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.sources > /dev/null
