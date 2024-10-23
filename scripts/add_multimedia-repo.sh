#!/usr/bin/env bash

sudo echo "deb https://www.deb-multimedia.org testing main non-free" > deb-multimedia.list
sudo mv ./deb-multimedia.list /etc/apt/sources.list.d/deb-multimedia.list
sudo apt-get update -oAcquire::AllowInsecureRepositories=true
sudo apt-get install deb-multimedia-keyring -y --allow-unauthenticated
sudo apt-get update
sudo apt-get dist-upgrade
