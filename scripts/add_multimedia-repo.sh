#!/usr/bin/env bash

# old way of doing it
#sudo echo "deb https://www.deb-multimedia.org testing main non-free" > deb-multimedia.list
#sudo mv ./deb-multimedia.list /etc/apt/sources.list.d/deb-multimedia.list

# create .sources file
echo '
Types: deb
URIs: https://www.deb-multimedia.org
Suites: testing
Components: main non-free
Signed-By: /usr/share/keyrings/deb-multimedia-keyring.pgp
Enabled: yes
' > /etc/apt/sources.list.d/deb-multimedia.sources

sudo apt-get update -oAcquire::AllowInsecureRepositories=true
sudo apt-get install deb-multimedia-keyring -y --allow-unauthenticated
