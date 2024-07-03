#!/bin/bash
### run as user, not root
### Inspired by... https://gitlab.com/thelinuxcast/scripts/-/blob/master/setup.sh

### set variables for commonly refered to directories
dotfiles="$HOME/.dotfiles"
gitstuff="$HOME/.git-stuff"
scripts="$HOME/.my-scripts"

### create directories needed for scripts and stuff
cd ~
mkdir .dotfiles
mkdir .git-stuff
mkdir .my-scripts

### create user directories in home folder
xdg-user-dirs-update

### install nerd-fonts
cd $gitstuff
echo -e "\033[36m 📥 Downloading Nerd Fonts 📥 \033[0m"
echo -e "\033[36m (⸝⸝ᴗ﹏ᴗ⸝⸝) ᶻ 𝗓 𐰁 this might take a while... \033[0m"
echo -e "\033[36m ( ͡° ͜ʖ ͡°)🔪( ͠° ͟ʖ ͡°) please do not kill me \033[0m"
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
echo -e "\033[36m ٩(ˊᗜˋ*)و 🛠️ Installing Nerd Fonts 🛠️ \033[0m"
cd nerd-fonts

### my favorite sans-serif font in firefox
./install.sh CodeNewRoman 

### my favorite font for basically everything
./install.sh Mononoki

### I like these for various things here and there
./install.sh CascadiaCode DaddyTimeMono DejaVuSansMono FantasqueSansMono Iosevka JetBrainsMono Monofur OpenDyslexic

### link user fonts to a directory accessible by all users and groups
cd ~
sudo ln -s ~/.local/share/fonts/NerdFonts/ /usr/share/fonts/

### start with some bare nessessities...
echo -e "\033[36m ٩(ˊᗜˋ*)و 🛠️ Installing Dependencies 🛠️ \033[0m"
sudo apt install -y nala fonts-font-awesome fonts-roboto fonts-recommended fonts-noto-color-emoji aria2 bash-completion eza lolcat micro nano zoxide figlet fastfetch

### start using nala
nala --install-completion bash
sudo nala install -y faker gawk jq fzf bat cava ripgrep duf jpegoptim jpegqs cbonsai npm golang speedtest-cli sway swayidle swaybg swaylock sway-notification-center playerctl wayland-utils meteo-qt qt5-image-formats-plugins qt5-qmltooling-plugins python3-genshi pulseaudio pavumeter pavucontrol paprefs wayland-protocols xwayland waybar wofi pcmanfm alacritty kitty exfat-fuse ntfs-3g netselect-apt btop cmatrix shotwell ostree appstream-util exiv2 gstreamer1.0-alsa ffmpeg mencoder webp libasound2-dev python3-i3ipc python3-geopy python3-pkgconfig libssl-dev libgtk-3-dev libcairo2-dev libglib2.0-dev mediainfo mediainfo-gui mpd ncmpcpp mpv gtk2-engines-murrine gtk2-engines-pixbuf rofi neofetch pulsemixer python3 pip pipx cargo tldr git flatpak xdg-user-dirs xdg-utils yt-dlp zip unzip p7zip-full libsndfile1-dev plymouth plymouth-themes python-is-python3 dos2unix build-essential libpam0g-dev libxcb-xkb-dev debian-archive-keyring curl gpg apt-transport-https  vrms

### install flatpak & use flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install com.github.tchx84.Flatseal com.vscodium.codium io.gitlab.librewolf-community io.github.shiftey.Desktop com.makemkv.MakeMKV io.github.giantpinkrobots.flatsweep xyz.tytanium.DoorKnocker

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
pipx install fart
pipx install ffmpeg-normalize
pipx install future
pipx install gruvbox-factory
pipx install jellyfin-tools
pipx install markdown
pipx install matchering --include-deps
pipx install plexapi
pipx install protontricks
pipx install rembg[gpu,cli]
pipx install rtcqs
pipx install sacad
pipx install streamrip 

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

### download wallpapers
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Wallpapers 📥 \033[0m"
cd ~
git clone https://github.com/botus99/.wallpapers.git

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

### download & install Matcha-dark-aliz
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing Matcha-dark-aliz theme 📥 \033[0m"
#cd $gitstuff
#git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
#cd Matcha-gtk-theme
#sudo ./install.sh --color dark --theme aliz --libadwaita
#./install.sh --color dark --theme aliz --libadwaita
#cd ~

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

### download and install papirus-icon-theme to ~/.local/share/icons
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

### download & install ArcDusk-Cursors
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing ArcDusk-Cursors 📥 \033[0m"
cd $gitstuff
git clone https://github.com/yeyushengfan258/ArcDusk-Cursors.git
cd ArcDusk-Cursors
sudo ./install.sh
./install.sh
cd ~

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

### download & install termv
#echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing termv 📥 \033[0m"
#cd $gitstuff
#git clone https://github.com/Roshan-R/termv.git
#cd termv
#sudo make install
#cd ~

### download & install glow
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading & Installing glow 📥 \033[0m"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo nala update && sudo nala install glow

### dotfile installation
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Dotfiles 📥 \033[0m"
cd ~
git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Installing Dotfiles 🛠️ \033[0m"
#cd $dotfiles
ln -s $HOME/.dotfiles/.config/alacritty ~/.config
ln -s $HOME/.dotfiles/.config/btop ~/.config
ln -s $HOME/.dotfiles/.config/cava ~/.config
ln -s $HOME/.dotfiles/.config/gtk-3.0 ~/.config
ln -s $HOME/.dotfiles/.config/kitty ~/.config
ln -s $HOME/.dotfiles/.config/fastfetch ~/.config
ln -s $HOME/.dotfiles/.config/glow ~/.config
ln -s $HOME/.dotfiles/.config/nwg-look ~/.config
ln -s $HOME/.dotfiles/.config/pcmanfm ~/.config
ln -s $HOME/.dotfiles/.config/rofi ~/.config
ln -s $HOME/.dotfiles/.config/sway ~/.config
ln -s $HOME/.dotfiles/.config/swaync ~/.config
ln -s $HOME/.dotfiles/.config/swaylock ~/.config
ln -s $HOME/.dotfiles/.config/waybar ~/.config

### success message
echo -e "(੭˃ᴗ˂)੭ OOOOOOOOOO YEAHHHHHH!!! "
echo -e "d-(´▽｀)-b Looks like we're good here "
echo -e "Restart me now & we can start the party! ( ˘ ³˘)♥︎ Woooooo!!!! 🎉🎊💦"
