#!/usr/bin/env bash
sudo echo "deb https://www.deb-multimedia.org testing main non-free" > deb-multimedia.list
sudo mv ./deb-multimedia.list /etc/apt/sources.list.d/deb-multimedia.list
apt-get update -oAcquire::AllowInsecureRepositories=true
apt-get install deb-multimedia-keyring -y
apt-get update
apt-get dist-upgrade
