#!/usr/bin/env bash

# Exit script if something fails
set -euo pipefail

# Check if the script is being run as root
### this script was designed to be run as a user, not root
### remove this portion at your own risk (...or for fun!)
if [ "$(id -u)" -eq 0 ]; then
    echo "🛃 This script must be run as a regular user. 🛃"
    echo "🙅‍♂️ No sudo either... please, just don't. 🙅‍♂️"
    exit 1
fi

# START AT HOME BASE & SET VARIABLES
cd "$HOME"

### set variables
GITDIR="$HOME/.git-stuff"
NFDIR="$HOME/.local/share/fonts/NerdFonts"

### create directories needed for scripts and stuff
mkdir -p "$GITDIR"
mkdir -p "$NFDIR"

# INSTALL FONTS
### beginning message
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Downloading & Installing Nerd Fonts 🛠️ \033[0m"

### enter NerdFonts directory
cd "$NFDIR"

### download and install fonts
FONTS=(
    "CodeNewRoman"
    "Mononoki"
    "CascadiaCode"
    "DaddyTimeMono"
    "DejaVuSansMono"
    "FantasqueSansMono"
    "Iosevka"
    "JetBrainsMono"
    "Monofur"
    "OpenDyslexic"
)

for FONT in "${FONTS[@]}"; do
    wget -P "$NFDIR" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.tar.xz"
    tar -xf "${FONT}.tar.xz"
    rm "${FONT}.tar.xz"
done

### link user NerdFonts directory to system fonts directory
cd "$HOME"
sudo ln -s "$HOME/.local/share/fonts/NerdFonts/" "/usr/share/fonts/"

### update font cache
fc-cache -fv

### success message
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و Nerd Fonts successfully installed ✅ \033[0m"

# INSTALL GTK THEME
### download & install Colloid-Red-Dark-Gruvbox GTK theme
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Colloid-Red-Compact-Gruvbox themes 📥 \033[0m"
cd "$GITDIR"
git clone https://github.com/vinceliuice/Colloid-gtk-theme.git
cd Colloid-gtk-theme
sudo ./install.sh --theme red --libadwaita system --size compact --tweaks gruvbox
./install.sh --theme red --libadwaita system --size compact --tweaks gruvbox
cd "$HOME"

### setup gtk-4.0 links
ln -s "$HOME/.local/share/themes/Colloid-Red-Dark-Compact-Gruvbox/gtk-4.0/assets/" "$HOME/.config/gtk-4.0/assets"
ln -s "$HOME/.local/share/themes/Colloid-Red-Dark-Compact-Gruvbox/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -s "$HOME/.local/share/themes/Colloid-Red-Dark-Compact-Gruvbox/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
ln -s "$HOME/.local/share/themes/Colloid-Red-Dark-Compact-Gruvbox/gtk-4.0/thumbnail.png" "$HOME/.config/gtk-4.0/thumbnail.png"

### fix flatpak apps
sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0

### success message
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و Colloid-Red-Dark-Compact-Gruvbox GTK theme successfully installed ✅ \033[0m"

### download & install Matcha-dark-aliz
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Matcha-dark-aliz theme 📥 \033[0m"
#cd "$GITDIR"
#git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
#cd Matcha-gtk-theme
#sudo ./install.sh --color dark --theme aliz --libadwaita
#./install.sh --color dark --theme aliz --libadwaita
#cd "$HOME"

# INSTALL ICONS
### download and install papirus-icon-theme to user's shared icons directory
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh

### download & install gruvbox-papirus folders
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing gruvbox-papirus-folders 📥 \033[0m"
cd "$GITDIR"
git clone https://github.com/xelser/gruvbox-papirus-folders
cd gruvbox-papirus-folders
cp -r "src/*" "$HOME/.local/share/icons/Papirus/"
./papirus-folders -C gruvbox-original-red --theme Papirus
cd "$HOME"

### download & install Vimix Ruby icons
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Vimix Ruby icons 📥 \033[0m"
#cd "$GITDIR"
#git clone https://github.com/vinceliuice/vimix-icon-theme.git
#cd vimix-icon-theme
#sudo ./install.sh ruby
#./install.sh ruby
#cd "$HOME"

### success message
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و gruvbox-papirus-folders successfully installed ✅ \033[0m"

# INSTALL CURSORS
### download & install ArcDusk-Cursors
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing ArcDusk-Cursors 📥 \033[0m"
#cd "$GITDIR"
#git clone https://github.com/yeyushengfan258/ArcDusk-Cursors.git
#cd ArcDusk-Cursors
#sudo ./install.sh
#./install.sh
#cd "$HOME"

### download & install Banana-cursor
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Banana-cursor 📥 \033[0m"
#wget https://github.com/ful1e5/banana-cursor/releases/download/v2.0.0/Banana.tar.xz
#tar -xvf Banana.tar.gz
#sudo mv Banana /usr/share/icons/
#rm ./Banana.tar.gz

### success message
#echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و Banana-cursor successfully installed ✅ \033[0m"

# INSTALL THEMING APPS
### download & install nwg-look
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing nwg-look 📥 \033[0m"
cd "$GITDIR"
git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
sudo make install
cd "$HOME"
### success message
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و nwg-look successfully installed ✅ \033[0m"

### download & install stylepak
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing stylepak 📥 \033[0m"
cd "$GITDIR"
git clone https://github.com/refi64/stylepak.git
cd stylepak
### install current gtk theme for flatpak apps
sudo ./stylepak install-system
./stylepak install-user
cd "$HOME"
### success message
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و stylepak successfully installed ✅ \033[0m"

### download & install plymouth themes
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing plymouth-themes 📥 \033[0m"
#cd "$GITDIR"
#git clone https://github.com/adi1090x/plymouth-themes.git 
#sudo mv "$GITDIR/plymouth-themes/pack_3/owl /usr/share/plymouth/themes/owl"
#sudo mv "$GITDIR/plymouth-themes/pack_4/red_loader /usr/share/plymouth/themes/red_loader"
#sudo git clone https://github.com/krishnan793/PlymouthTheme-Cat.git /usr/share/plymouth/themes/PlymouthTheme-Cat
#sudo plymouth-set-default-theme PlymouthTheme-Cat -R
#
#sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/PlymouthTheme-Cat/PlymouthTheme-Cat.plymouth 100
#sudo update-alternatives --config default.plymouth
#sudo update-initramfs -u
### success message
#echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و plymouth-themes successfully installed ✅ \033[0m"

### download wallpapers
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Wallpapers 📥 \033[0m"
cd "$HOME"
git clone https://github.com/botus99/.wallpapers.git
echo -e "\033[36m ✅ ٩(ˊᗜˋ*)و wallpapers successfully downloaded ✅ \033[0m"

### success message
echo -e "🎊 (੭˃ᴗ˂)੭ OOOO LA LA!!! Let's put on your new threads!"
echo -e "Open nwg-look and/or your system theming app to setup your themes"
echo -e "Remember to run stylepak after that to theme your flatpak applications"
echo -e "🎊 d-(´▽｀)-b Hope you enjoy the new look!"