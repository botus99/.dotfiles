#!/usr/bin/env bash

# Inspired by... https://gitlab.com/thelinuxcast/scripts/-/blob/master/setup.sh

# Check if the script is being run as root
### this script was designed to be run as a user, not root
### remove this portion at your own risk (...or for fun!)
if [ "$(id -u)" -eq 0 ]; then
    echo "🛃 This script must be run as a regular user. 🛃"
    echo "🙅‍♂️ No sudo either... please, just don't. 🙅‍♂️"
    exit 1
fi

### set variables for commonly refered to directories
gitstuff="$HOME/.git-stuff"
scripts="$HOME/.my-scripts"

### create directories needed for scripts and stuff
cd ~
mkdir .git-stuff
mkdir .my-scripts

### create user directories in home folder
xdg-user-dirs-update

### start with some bare nessessities...
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Installing Dependencies 🛠️ \033[0m"
sudo apt-get update
sudo apt-get install -y nala fonts-weather-icons fonts-font-awesome fonts-roboto fonts-recommended fonts-noto-color-emoji aria2 bash-completion eza lolcat micro nano zoxide figlet fastfetch fonts-material-design-icons-iconfont

### start using nala
nala --install-completion bash
sudo nala install -y pwgen xdotool python3-feedparser faker gawk jq fzf bat cava ripgrep duf jpegoptim jpegqs cbonsai npm golang speedtest-cli qrencode cinnamon-desktop-environment sway swayidle swaybg swaylock sway-notification-center playerctl wayland-utils qt5-image-formats-plugins qt5-qmltooling-plugins python3-genshi pulseaudio pavumeter pavucontrol paprefs wayland-protocols xwayland waybar wofi pcmanfm alacritty kitty exfat-fuse ntfs-3g netselect-apt btop cmatrix shotwell ostree appstream-util exiv2 gstreamer1.0-alsa ffmpeg mencoder webp libasound2-dev python3-i3ipc python3-geopy python3-pkgconfig libssl-dev libgtk-3-dev libcairo2-dev libglib2.0-dev mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf rofi timg inotify-tools pulsemixer python3 python3-pip pipx cargo tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip p7zip-full libsndfile1-dev polybar plymouth plymouth-themes python-is-python3 dos2unix build-essential libpam0g-dev libxcb-xkb-dev debian-archive-keyring curl gpg apt-transport-https vrms

### install flatpak & use flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install net.nokyan.Resources com.github.tchx84.Flatseal com.usebottles.bottles net.davidotek.pupgui2 com.valvesoftware.Steam io.github.Foldex.AdwSteamGtk com.vscodium.codium com.makemkv.MakeMKV fr.handbrake.ghb io.github.giantpinkrobots.flatsweep io.github.zen_browser.zen io.gitlab.librewolf-community io.github.ungoogled_software.ungoogled_chromium net.pcsx2.PCSX2 org.DolphinEmu.dolphin-emu org.libretro.RetroArch org.ryujinx.Ryujinx org.upscayl.Upscayl xyz.tytanium.DoorKnocker

### install Distrotube's color scripts
cd $gitstuff
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
cd ~

### install alacritty themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

### install ly display manager
#echo -e "\033[36m 🐍 ٩(ˊᗜˋ*)و Installing Ly Display Manager 🐍 \033[0m"
#cd $gitstuff
#git clone --recurse-submodules https://github.com/fairyglade/ly
#cd ly
#sudo make
#sudo make install installsystemd
#sudo systemctl enable ly.service
#cd ~

### install python apps
echo -e "\033[36m 🐍 ٩(ˊᗜˋ*)و Installing Python Apps 🐍 \033[0m"
pipx install drmeter
pipx install fart
pipx install ffmpeg-normalize
pipx install future
pipx install gruvbox-factory
pipx install jellyfin-tools
pipx install markdown
pipx install plexapi
pipx install protontricks
pipx install pyflac
pipx install rembg[gpu,cli]
pipx install rtcqs
pipx install sacad
pipx install streamrip 
pipx install tqdm

### install rust apps
echo -e "\033[36m 🦀 ٩(ˊᗜˋ*)و Installing Rust Apps 🦀 \033[0m"
cargo install bropages
cargo install cargo-update
cargo install cfonts
cargo install code-radio-cli
cargo install gifski
cargo install mfp --locked
cargo install names
cargo install oxipng

### download & install tgpt
curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin

### download & install termv
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing termv 📥 \033[0m"
cd $gitstuff
git clone https://github.com/Roshan-R/termv.git
cd termv
sudo make install
cd ~

### download & install glow & vhs
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing glow 📥 \033[0m"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo nala update && sudo nala install glow vhs

### success message
echo -e "🎊 (੭˃ᴗ˂)੭ OOOOOOOOOO YEAHHHHHH!!!"
echo -e "🎉 d-(´▽｀)-b Looks like we're good here"
echo -e "🗘 Restart me now & then we can party!"
