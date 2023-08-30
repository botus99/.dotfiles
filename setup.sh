#!/bin/bash
### Inspired by... https://gitlab.com/thelinuxcast/scripts/-/blob/master/setup.sh?ref_type=heads

dotfiles="$HOME/.dotfiles"
gitstuff="$HOME/.git-stuff"
scripts="$HOME/.my-scripts"

mkdir .dotfiles
mkdir .git-stuff
mkdir .my-scripts

### install nerd-fonts
cd $gitstuff
echo -e "\033[36m Installing Nerd Fonts \033[0m"
echo -e "\033[36m this might take a while... \033[0m"
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
./install.sh FiraMono FiraCode Iosevka IosevkaTerm Monofur Mononoki 

### bare nessessities
echo -e "\033[36m Installing Dependencies \033[0m"
### start with some basics...
sudo apt install nala fonts-font-awesome fonts-mononoki fonts-roboto fonts-recommended fonts-noto-color-emoji aria2 bash-completion exa lolcat nano -y
### start using nala
nala --install-completion bash
sudo nala install sway swayidle swaybg swaylock wayland-utils wayland-protocols xwayland waybar wofi pcmanfm alacritty kitty btop cmatrix ffmpeg optipng webp libasound2-dev python3-pkgconfig libssl-dev mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf neofetch pulsemixer python3 pip pipx cargo tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip p7zip-full build-essential libpam0g-dev libxcb-xkb-dev debian-archive-keyring curl gpg apt-transport-https 
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install com.github.tchx84.Flatseal com.vscodium.codium io.gitlab.librewolf-community org.mozilla.Thunderbird

### import GPG key & enable repository for Firefox Progressive Web Apps extension
curl -fsSL https://packagecloud.io/filips/FirefoxPWA/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/firefoxpwa-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/firefoxpwa-keyring.gpg] https://packagecloud.io/filips/FirefoxPWA/any any main" | sudo tee /etc/apt/sources.list.d/firefoxpwa.list > /dev/null
sudo nala update
sudo nala install firefoxpwa

### install python apps
pipx install streamrip 

### install rust apps
#cargo install mfp
cargo install code-radio-cli

### download & install wallpapers
echo -e "\033[36m Downloading Wallpapers \033[0m"
cd ~
git clone https://github.com/botus99/.wallpapers.git

### download & install plymouth themes
echo -e "\033[36m Downloading Themes for Plymouth \033[0m"
cd $gitstuff
git clone https://github.com/adi1090x/plymouth-themes.git 
sudo apt install plymouth
mv $gitstuff/plymouth-themes/Pack_3/owl /usr/share/plymouth/themes/owl
mv $gitstuff/plymouth-themes/Pack_4/red_loader /usr/share/plymouth/themes/red_loader
sudo git clone https://github.com/krishnan793/PlymouthTheme-Cat.git /usr/share/plymouth/themes/PlymouthTheme-Cat
sudo plymouth-set-default-theme PlymouthTheme-Cat -R

### dotfile installation
echo -e "\033[36m Downloading Dotfiles \033[0m"
cd ~
git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m Installing Dotfiles \033[0m"
#cd $dotfiles
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

### create user directories in home folder
xdg-user-dirs-update

### success message
echo -e "Alllllllllrighty then!!! Looks like we're good here. Just restart me now and we can start the party! Woooooo!!!!"
