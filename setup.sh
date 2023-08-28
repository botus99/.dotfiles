#!/bin/bash
# Inspired by... https://gitlab.com/thelinuxcast/scripts/-/blob/master/setup.sh?ref_type=heads

dotfiles="$HOME/.dotfiles"
gitstuff="$HOME/.github-stuff"
scripts="$HOME/.my-scripts"

mkdir .dotfiles
mkdir .github-stuff
mkdir .my-scripts

# install nerd-fonts
cd $gitstuff
echo -e "\033[36m Installing Nerd Fonts \033[0m"
echo -e "\033[36m this might take a while... \033[0m"
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
./install.sh FiraMono FiraCode Iosevka IosevkaTerm Monofur Mononoki 

# bare nessessities
echo -e "\033[36m Installing Dependencies \033[0m"
sudo apt install nala fonts-font-awesome aria2c bash-completion exa lolcat nano -y
nala --install-completion bash
sudo nala install sway swayidle swaybg swaylock wayland-utils wayland-protocols xwayland waybar wofi pcmanfm alacritty kitty btop cmatrix ffmpeg optipng mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf neofetch pulsemixer python3 pipx tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip p7zip-full build-essential libpam0g-dev libxcb-xkb-dev
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install com.github.tchx84.Flatseal com.vscodium.codium io.gitlab.librewolf-community org.mozilla.Thunderbird

# dotfile installation
echo -e "\033[36m Downloading Dotfiles \033[0m"
cd && git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m Installing Dotfiles \033[0m"

cd $dotfiles
ln -s $HOME/.dotfiles/.config/sway ~/.config
ln -s $HOME/.dotfiles/.config/swaylock ~/.config
ln -s $HOME/.dotfiles/.config/alacritty ~/.config
ln -s $HOME/.dotfiles/.config/kitty ~/.config
ln -s $HOME/.dotfiles/.config/waybar ~/.config
ln -s $HOME/.dotfiles/.config/wofi ~/.config
ln -s $HOME/.dotfiles/.config/btop ~/.config
#rm -r ~/.config/neofetch && ln -s $HOME/.dotfiles/.config/neofetch ~/.config

#cd $gitstuff && git clone https://gitlab.com/thelinuxcast/scripts.git
#cd $scripts
#sudo cp *.sh weather.py /usr/local/bin

#cd $HOME/.config
#git clone https://gitlab.com/thelinuxcast/nvim.git
echo -e "Alllllllllrighty then!!! Looks like we're good here. Just restart me now and we can start the party! Woooooo!!!!"