#!/bin/bash
sudo apt-get install libsndfile1-dev
cd $HOME/.git-stuff
git clone https://github.com/x42/sound-gambit.git
cd sound-gambit
make
ln -s $HOME/.git-stuff/sound-gambit/sound-gambit $HOME/.local/bin/sound-gambit
# comment out the ln command above and uncomment out the make command below to install instead of linking to your local bin
#sudo make install PREFIX=/usr
