#!/usr/bin/env bash
### run as user, not root

# START AT HOME BASE & SET VARIABLES
cd ~

### set variables for commonly refered to directories
gitstuff="$HOME/.git-stuff"

### create directories needed for scripts and stuff
mkdir .git-stuff

# INSTALL FONTS
### beginning message
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Installing Nerd Fonts 🛠️ \033[0m"

### create and enter NerdFonts directory
mkdir -p "$HOME/.local/share/fonts/NerdFonts"
cd "$HOME/.local/share/fonts/NerdFonts"

### my favorite sans-serif font in firefox
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CodeNewRoman.tar.xz"
tar -xf "CodeNewRoman.tar.xz"
rm "CodeNewRoman.tar.xz"

### my favorite font for basically everything
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz"
tar -xf "Mononoki.tar.xz"
rm "Mononoki.tar.xz"

### more fonts for various things here and there
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.tar.xz"
tar -xf "CascadiaCode.tar.xz"
rm "CascadiaCode.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DaddyTimeMono.tar.xz"
tar -xf "DaddyTimeMono.tar.xz"
rm "DaddyTimeMono.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.tar.xz"
tar -xf "DejaVuSansMono.tar.xz"
rm "DejaVuSansMono.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FantasqueSansMono.tar.xz"
tar -xf "FantasqueSansMono.tar.xz"
rm "FantasqueSansMono.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.tar.xz"
tar -xf "Iosevka.tar.xz"
rm "Iosevka.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
tar -xf "JetBrainsMono.tar.xz"
rm "JetBrainsMono.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monofur.tar.xz"
tar -xf "Monofur.tar.xz"
rm "Monofur.tar.xz"

wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/OpenDyslexic.tar.xz"
tar -xf "OpenDyslexic.tar.xz"
rm "OpenDyslexic.tar.xz"

### link user NerdFonts directory to system fonts directory
cd ~
sudo ln -s ~/.local/share/fonts/NerdFonts/ /usr/share/fonts/

### update font cache
fc-cache -fv

# INSTALL GTK THEME
### download & install Colloid-Red-Dark-Gruvbox GTK theme
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Colloid-Red-Dark-Gruvbox theme 📥 \033[0m"
cd $gitstuff
git clone https://github.com/vinceliuice/Colloid-gtk-theme.git
cd Colloid-gtk-theme
sudo ./install.sh --color dark --theme red --libadwaita system --tweaks gruvbox
./install.sh --color dark --theme red --libadwaita system --tweaks gruvbox
cd ~

### setup gtk-4.0 links
ln -s $HOME/.themes/Colloid-Red-Dark-Gruvbox/gtk-4.0/assets/ $HOME/.config/gtk-4.0/assets
ln -s $HOME/.themes/Colloid-Red-Dark-Gruvbox/gtk-4.0/gtk.css $HOME/.config/gtk-4.0/gtk.css
ln -s $HOME/.themes/Colloid-Red-Dark-Gruvbox/gtk-4.0/gtk-dark.css $HOME/.config/gtk-4.0/gtk-dark.css
ln -s $HOME/.themes/Colloid-Red-Dark-Gruvbox/gtk-4.0/thumbnail.png $HOME/.config/gtk-4.0/thumbnail.png

### download & install Matcha-dark-aliz
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Matcha-dark-aliz theme 📥 \033[0m"
#cd $gitstuff
#git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
#cd Matcha-gtk-theme
#sudo ./install.sh --color dark --theme aliz --libadwaita
#./install.sh --color dark --theme aliz --libadwaita
#cd ~

# INSTALL ICONS
### download and install papirus-icon-theme to user's shared icons directory
wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh

### download & install gruvbox-papirus folders
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing gruvbox-papirus-folders 📥 \033[0m"
cd $gitstuff
git clone https://github.com/xelser/gruvbox-papirus-folders
cd gruvbox-papirus-folders
cp -r src/* $HOME/.local/share/icons/Papirus/
./papirus-folders -C gruvbox-original-red --theme Papirus
cd ~

### download & install Vimix Ruby icons
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Vimix Ruby icons 📥 \033[0m"
#cd $gitstuff
#git clone https://github.com/vinceliuice/vimix-icon-theme.git
#cd vimix-icon-theme
#sudo ./install.sh ruby
#./install.sh ruby
#cd ~

# INSTALL CURSORS
### download & install ArcDusk-Cursors
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing ArcDusk-Cursors 📥 \033[0m"
cd $gitstuff
git clone https://github.com/yeyushengfan258/ArcDusk-Cursors.git
cd ArcDusk-Cursors
sudo ./install.sh
./install.sh
cd ~

### download & install Banana-cursor
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Banana-cursor 📥 \033[0m"
wget https://github.com/ful1e5/banana-cursor/releases/download/v2.0.0/Banana.tar.xz
tar -xvf Banana.tar.gz
sudo mv Banana /usr/share/icons/
rm ./Banana.tar.gz

# INSTALL THEMING APPS
### download & install nwg-look
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing nwg-look 📥 \033[0m"
cd $gitstuff
git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
sudo make install
cd ~

### download & install stylepak
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing stylepak 📥 \033[0m"
cd $gitstuff
git clone https://github.com/refi64/stylepak.git
cd stylepak
### install current gtk theme for flatpak apps
sudo ./stylepak install-system
./stylepak install-user
cd ~

### download & install plymouth themes
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Themes for Plymouth 📥 \033[0m"
#cd $gitstuff
#git clone https://github.com/adi1090x/plymouth-themes.git 
#sudo mv $gitstuff/plymouth-themes/pack_3/owl /usr/share/plymouth/themes/owl
#sudo mv $gitstuff/plymouth-themes/pack_4/red_loader /usr/share/plymouth/themes/red_loader
#sudo git clone https://github.com/krishnan793/PlymouthTheme-Cat.git /usr/share/plymouth/themes/PlymouthTheme-Cat
#sudo plymouth-set-default-theme PlymouthTheme-Cat -R
#
#sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/PlymouthTheme-Cat/PlymouthTheme-Cat.plymouth 100
#sudo update-alternatives --config default.plymouth
#sudo update-initramfs -u

### success message
echo -e "🎊 (੭˃ᴗ˂)੭ OOOO LA LA!!! Let's put on your new threads!"
echo -e "Open nwg-look and/or your system theming app to setup your themes"
echo -e "Remember to run stylepak after that to theme your flatpak applications"
echo -e "🎊 d-(´▽｀)-b Hope you enjoy the new look!"