#!/usr/bin/env bash
#
# install dependencies
sudo apt-get install fzf ueberzug -y
#
# download and install wppfzf
wget "https://github.com/channel-42/wppfzf/archive/v0.1.0.tar.gz" -O $HOME/wppfzf.tar.gz
mkdir $HOME/.wppfzf_d
tar -zxvf wppfzf.tar.gz -C $HOME/.wppfzf_d --strip-components 1
rm -f $HOME/wppfzf.tar.gz
cd $HOME/.wppfzf_d
sudo make install
# cleanup
cd $HOME
rm -rf $HOME/.wppfzf_d
