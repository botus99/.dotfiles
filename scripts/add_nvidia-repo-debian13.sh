#!/usr/bin/env bash
#
# NVIDIA begins support for Debian 13 - Trixie with the 590 update
# The 590 update breaks support for some older cards
# Please be sure that your card is new enough to support the 590 update before using this repo

sudo apt-get install dirmngr ca-certificates software-properties-common apt-transport-https dkms curl -y
curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/8793F200.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1

# old way
#echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/ /' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

echo '
Types: deb
URIs: https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/
Suites: /
Components:
Signed-By: /usr/share/keyrings/nvidia-drivers.gpg
' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.sources > /dev/null
