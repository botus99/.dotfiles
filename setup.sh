#!/bin/bash

dotfiles="$HOME/.dotfiles"
gitstuff="$HOME/.github-stuff"
scripts="$HOME/.myscripts"

# install nerd-fonts
cd $gitstuff
echo -e "\033[36m Installing Nerd Fonts \033[0m"
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
./install.sh FiraMono FiraCode Iosevka IosevkaTerm Monofur Mononoki 



# bare nessessities
echo -e "\033[36m Installing Dependencies \033[0m"
sudo apt install nala fonts-font-awesome aria2c -y
nala --install-completion bash
sudo nala install bash-completion exa lolcat nano sway swayidle swaybg swaylock qt6ct qt6-wayland wayland-utils wayland-protocols xwayland waybar wofi pcmanfm-qt alacritty kitty btop cmatrix ffmpeg optipng mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf cpufetch neofetch pulsemixer python3 pipx tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip unrar p7zip build-essential libpam0g-dev libxcb-xkb-dev
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
