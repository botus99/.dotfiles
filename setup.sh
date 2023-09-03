#!/bin/bash
### run as user, not root
### Inspired by... https://gitlab.com/thelinuxcast/scripts/-/blob/master/setup.sh?ref_type=heads

dotfiles="$HOME/.dotfiles"
gitstuff="$HOME/.git-stuff"
scripts="$HOME/.my-scripts"

cd ~
mkdir .dotfiles
mkdir .git-stuff
mkdir .my-scripts

### install nerd-fonts
cd $gitstuff
echo -e "\033[36m Installing Nerd Fonts \033[0m"
echo -e "\033[36m this might take a while... \033[0m"
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh Iosevka
./install.sh Monofur
./install.sh Mononoki
cd ~
sudo ln -s ~/.local/share/fonts/NerdFonts/ /usr/share/fonts/

### bare nessessities
echo -e "\033[36m Installing Dependencies \033[0m"

### start with some basics...
sudo apt install -y nala fonts-font-awesome fonts-mononoki fonts-roboto fonts-recommended fonts-noto-color-emoji aria2 bash-completion exa lolcat micro nano

### install oh-my-bash
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"

### switch Firefox to latest version
sudo nala remove -y firefox-esr
sudo nala install -y firefox

### start using nala
nala --install-completion bash
sudo nala install -y bat cava ripgrep duf npm golang sway swayidle swaybg swaylock sway-notification-center playerctl wayland-utils meteo-qt qt5-image-formats-plugins qt5-qmltooling-plugins python3-genshi pulseaudio pavumeter pavucontrol paprefs screenfetch wayland-protocols xwayland waybar wofi pcmanfm alacritty kitty netselect-apt btop cmatrix shotwell ostree appstream-util exiv2 gstreamer1.0-alsa ffmpeg optipng webp libasound2-dev python3-i3ipc python3-geopy python3-pkgconfig libssl-dev libgtk-3-dev libcairo2-dev libglib2.0-dev mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf neofetch pulsemixer python3 pip pipx cargo tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip p7zip-full plymouth plymouth-themes build-essential libpam0g-dev libxcb-xkb-dev debian-archive-keyring curl gpg apt-transport-https 

### install flatpak & use flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install com.github.tchx84.Flatseal com.vscodium.codium io.gitlab.librewolf-community io.github.shiftey.Desktop org.gnome.Evolution

### import GPG key & enable repository for Firefox Progressive Web Apps extension
curl -fsSL https://packagecloud.io/filips/FirefoxPWA/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/firefoxpwa-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/firefoxpwa-keyring.gpg] https://packagecloud.io/filips/FirefoxPWA/any any main" | sudo tee /etc/apt/sources.list.d/firefoxpwa.list > /dev/null
sudo nala update
sudo nala install -y firefoxpwa

### install Distrotube's color scripts
cd $gitstuff
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
cd ~

### install alacritty themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

### install ly display manager
cd $gitstuff
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
sudo make
sudo make install installsystemd
sudo systemctl enable ly.service
cd ~

### install python apps
pipx install streamrip 

### install rust apps
cargo install mfp --locked
cargo install code-radio-cli

### download & install wallpapers
echo -e "\033[36m Downloading Wallpapers \033[0m"
cd ~
git clone https://github.com/botus99/.wallpapers.git

### download & install plymouth themes
echo -e "\033[36m Downloading Themes for Plymouth \033[0m"
cd $gitstuff
git clone https://github.com/adi1090x/plymouth-themes.git 
mv $gitstuff/plymouth-themes/pack_3/owl /usr/share/plymouth/themes/owl
mv $gitstuff/plymouth-themes/pack_4/red_loader /usr/share/plymouth/themes/red_loader
sudo git clone https://github.com/krishnan793/PlymouthTheme-Cat.git /usr/share/plymouth/themes/PlymouthTheme-Cat
sudo plymouth-set-default-theme PlymouthTheme-Cat -R

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/PlymouthTheme-Cat/PlymouthTheme-Cat.plymouth 100
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u

### dotfile installation
echo -e "\033[36m Downloading Dotfiles \033[0m"
cd ~
git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m Installing Dotfiles \033[0m"
#cd $dotfiles
ln -s $HOME/.dotfiles/.config/alacritty ~/.config
ln -s $HOME/.dotfiles/.config/btop ~/.config
ln -s $HOME/.dotfiles/.config/kitty ~/.config
ln -s $HOME/.dotfiles/.config/sway ~/.config
ln -s $HOME/.dotfiles/.config/swaync ~/.config
ln -s $HOME/.dotfiles/.config/swaylock ~/.config
ln -s $HOME/.dotfiles/.config/waybar ~/.config
ln -s $HOME/.dotfiles/.config/wofi ~/.config
#rm -r ~/.config/neofetch && ln -s $HOME/.dotfiles/.config/neofetch ~/.config

#cd $gitstuff && git clone https://gitlab.com/thelinuxcast/scripts.git
#cd $scripts
#sudo cp *.sh weather.py /usr/local/bin

### create user directories in home folder
xdg-user-dirs-update

### success message
echo -e "Alllllllllrighty then!!! Looks like we're good here. Just restart me now and we can start the party! Woooooo!!!!"
