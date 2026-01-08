#!/usr/bin/env bash
#
# This script is designed to work with Debian Testing.
#
# I WILL add/remove apps from here, change things around, or just rewrite things
# for whatever reason I feel like at the time. This script is very opinionated,
# and it is a constant work-in-progress.
#
# Be sure to substitute your preferred options wherever you want them.
# This script was written by myself, for myself. Have fun making it yours!

# =========================================================================== #
#                             CHECK YOUR PRIVILEGE                            #
# =========================================================================== #

# this script was designed to be run as a user, not root
# remove this portion at your own risk (...or for fun!)

if [ "$(id -u)" -eq 0 ]; then
    echo "🛃 This script must be run as a regular user. 🛃"
    echo "🙅‍♂️ No sudo either... please, just don't. 🙅‍♂️"
    exit 1
fi

# =========================================================================== #
#                              SET YOUR VARIABLES                             #
# =========================================================================== #

GIT_STUFF="$HOME/.git-stuff"
SCRIPTS_DIR="$HOME/.my-scripts"

# =========================================================================== #
#                            MAKE YOUR DIRECTORIES                            #
# =========================================================================== #

cd "$HOME" || exit
xdg-user-dirs-update
mkdir "$GIT_STUFF"
mkdir "$SCRIPTS_DIR"

# =========================================================================== #
#                                 DEB INSTALLS                                #
# =========================================================================== #

# just getting started here...
sudo apt-get update

INSTALL_DEPS() {
    echo -e "\033[36m| --- 🛠️ Installing Dependencies 🛠️ --- |\033[0m"
    sudo apt-get install -y \
        apt-transport-https \
        aria2 \
        bash-completion \
        ca-certificates \
        curl \
        debian-archive-keyring \
        eza \
        flatpak \
        git \
        gpg \
        lolcat \
        micro \
        nala \
        nano \
        fastfetch \
        figlet \
        fonts-font-awesome \
        fonts-material-design-icons-iconfont \
        fonts-noto-color-emoji \
        fonts-recommended \
        fonts-roboto \
        fonts-weather-icons \
        zoxide
}

INSTALL_DEPS

# nala
nala --install-completion bash

INSTALL_DEBS() {
    case "$1" in
        "cinnamon")
            sudo apt-get install -y \
                cinnamon-desktop-environment
            ;;
        "devel")
            sudo apt-get install -y \
                build-essential \
                cargo \
                dos2unix \
                gawk \
                golang \
                npm \
                pipx \
                python3 \
                python3-feedparser \
                python3-genshi \
                python3-geopy \
                python3-i3ipc \
                python3-pkgconfig \
                python3-pip \
                python-is-python3
            ;;
        "desktop")
            sudo apt-get install -y \
                pcmanfm \
                plymouth \
                plymouth-themes \
                polybar \
                rofi \
                wayland-protocols \
                wayland-utils \
                xdg-desktop-portal \
                xdg-desktop-portal-gtk \
                xdg-desktop-portal-wlr \
                xdg-desktop-portal-xapp \
                xdg-terminal-exec \
                xdg-utils \
                xdotool \
                xwayland
            ;;
        "files")
            sudo apt-get install -y \
                exfat-fuse \
                ntfs-3g \
                p7zip-full \
                unzip \
                zip
            ;;
        "media")
            sudo apt-get install -y \
                ffmpeg \
                gstreamer1.0-alsa \
                gtk2-engines-murrine \
                gtk2-engines-pixbuf \
                jpegoptim \
                jpegqs \
                libasound2-dev \
                libcairo2-dev \
                libglib2.0-dev \
                libgtk-3-dev \
                libsndfile1-dev \
                libspa-0.2-jack \
                libssl-dev \
                libxcb-xkb-dev \
                mediainfo \
                mediainfo-gui \
                mencoder \
                mpd \
                mpv \
                ncmpcpp \
                paprefs \
                pavucontrol \
                pavumeter \
                pipewire-alsa \
                pipewire-audio \
                pipewire-audio-client-libraries \
                pipe \
                playerctl \
                pulseaudio \
                pulsemixer \
                qt5-image-formats-plugins \
                qt5-qmltooling-plugins \
                shotwell \
                webp \
                wire-jack
            ;;
        "terminal")
            sudo apt-get install -y \
                alacritty \
                batcat \
                btop \
                cava \
                cbonsai \
                cmatrix \
                ddgr \
                duf \
                faker \
                fzf \
                jq \
                kitty \
                less \
                netselect-apt \
                pwgen \
                qrencode \
                ripgrep \
                speedtest-cli \
                timg \
                tldr \
                yt-dlp
            ;;
        "system")
            sudo apt-get install -y \
                appstream-util \
                exiv2 \
                inotify-tools \
                libpam0g-dev \
                libxcb-xkb-dev \
                ostree \
                vrms \
                xdg-user-dirs
            ;;
        *)
            echo "Invalid category: $1"
            exit 1
            ;;
    esac
}

CHOOSE_DEBS_TO_INSTALL() {
    read -p "Install developer applications? (python, rust, go, etc...) [y/n]: " DEVEL_CHOICE
    if [[ $DEVEL_CHOICE == 'y' ]]; then
        INSTALL_DEBS devel
    fi

    read -p "Install desktop applications? (plymouth, polybar, rofi, etc...) [y/n]: " DESKTOP_CHOICE
    if [[ $DESKTOP_CHOICE == 'y' ]]; then
        INSTALL_DEBS desktop
    fi

    read -p "Install files applications? (exfat-fuse, ntfs-3g, p7zip-full) [y/n]: " FILES_CHOICE
    if [[ $FILES_CHOICE == 'y' ]]; then
        INSTALL_DEBS files
    fi

    read -p "Install media applications? (ffmpeg, mpd, mpv, mediainfo, etc...) [y/n]: " MEDIA_CHOICE
    if [[ $MEDIA_CHOICE == 'y' ]]; then
        INSTALL_DEBS media
        # Tell all apps that use JACK to now use the Pipewire JACK
        # credit to sikorak666 for the lines below
        sudo cp /usr/share/doc/pipewire/examples/ld.so.conf.d/pipewire-jack-*.conf /etc/ld.so.conf.d/
        sudo ldconfig
        sudo usermod -a -G pipewire $USER
    fi

    read -p "Install terminal applications? (btop, speedtest-cli, yt-dlp, etc...) [y/n]: " TERMINAL_CHOICE
    if [[ $TERMINAL_CHOICE == 'y' ]]; then
        INSTALL_DEBS terminal
        INSTALL_DISTROTUBE_COLOR_SCRIPTS() {
            cd "$GIT_STUFF" || exit
            git clone https://gitlab.com/dwt1/shell-color-scripts.git
            cd shell-color-scripts || exit
            sudo make install
            cd "$HOME" || exit
        }
        INSTALL_DISTROTUBE_COLOR_SCRIPTS
        git clone "https://github.com/alacritty/alacritty-theme" "$HOME/.config/alacritty/themes"
    fi

    read -p "Install system applications? (inotify-tools, ostree, xdg-user-dirs, etc...) [y/n]: " SYSTEM_CHOICE
    if [[ $SYSTEM_CHOICE == 'y' ]]; then
        INSTALL_DEBS system
    fi

    read -p "Install the Liquorix kernel? [y/n]: " LIQUORIX_CHOICE
    if [[ $LIQUORIX_CHOICE == 'y' ]]; then
        curl 'https://liquorix.net/add-liquorix-repo.sh' | sudo bash
        sudo apt-get update
        sudo apt-get install linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -y
    fi
}

CHOOSE_DEBS_TO_INSTALL

# =========================================================================== #
#                               FLATPAK INSTALLS                              #
# =========================================================================== #

ADD_FLATHUB_REMOTE() {
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

INSTALL_UTILITIES() {
    flatpak install net.nokyan.Resources com.github.tchx84.Flatseal com.usebottles.bottles com.vscodium.codium com.makemkv.MakeMKV io.github.giantpinkrobots.flatsweep org.upscayl.Upscayl xyz.tytanium.DoorKnocker
}

INSTALL_BROWSERS() {
    flatpak install io.github.zen_browser.zen io.gitlab.librewolf-community io.github.ungoogled_software.ungoogled_chromium
}

INSTALL_GAMING() {
    flatpak install com.valvesoftware.Steam com.valvesoftware.Steam.Utility.steamtinkerlaunch com.vysp3r.ProtonPlus org.libretro.RetroArch
}

INSTALL_FLATPAKS() {
    ADD_FLATHUB_REMOTE

    read -p "Install flatpak utilities? (Flatseal, Bottles, Resources, Doorknocker...) [y/n]: " UTILITY_CHOICE
    if [[ $UTILITY_CHOICE == 'y' ]]; then
        INSTALL_UTILITIES
    fi

    read -p "Install flatpak browsers? (Zen, Librewolf, Ungoogled Chromium) [y/n]: " BROWSER_CHOICE
    if [[ $BROWSER_CHOICE == 'y' ]]; then
        INSTALL_BROWSERS
    fi

    read -p "Install flatpak gaming apps? (ProtonPlus, RetroArch, Steam) [y/n]: " GAMING_CHOICE
    if [[ $GAMING_CHOICE == 'y' ]]; then
        INSTALL_GAMING
    fi
}

INSTALL_FLATPAKS

# =========================================================================== #
#                             INSTALL PYTHON APPS                             #
# =========================================================================== #

INSTALL_PYTHON_APPS() {
    echo -e "\033[36m| --- 🐍 Installing Python Apps 🐍 --- |\033[0m"

    local PIPX_APPS=(
        "drmeter"
        "fart"
        "ffmpeg-normalize"
        "future"
        "gruvbox-factory"
        "jellyfin-tools"
        "maigret"
        "manim"
        "markdown"
        "pdfplumber"
        "plexapi"
        "protontricks"
        "pwnedpasswords"
        "pyflac"
        "pymupdf"
        "pywal16"
        "rembg[gpu,cli]"
        "rtcqs"
        "sacad"
        "social-analyzer"
        "streamrip"
        "tqdm"
        "waypaper"
    )

    for APP in "${PIPX_APPS[@]}"; do
        pipx install "$APP" || { echo "Failed to install $APP"; exit 1; }
    done
    echo "All Python applications installed successfully!"
}

read -p "Install python apps? (drmeter, fart, gruvbox-factory, etc...) [y/n]: " PYTHON_CHOICE
if [[ $PYTHON_CHOICE == 'y' ]]; then
    INSTALL_PYTHON_APPS
fi

# =========================================================================== #
#                              INSTALL RUST APPS                              #
# =========================================================================== #

INSTALL_RUST_APPS() {
    echo -e "\033[36m| --- 🦀 Installing Rust Apps 🦀 --- |\033[0m"

    local CARGO_APPS=(
        "bandwhich"
        "bropages"
        "cargo-update"
        "cfonts"
        "charasay"
        "code-radio-cli"
        "gifski"
        "lovesay"
        "mfp --locked"
        "names"
        "oxipng"
        "presenterm"
        "systemd-manager-tui"
    )

    for APP in "${CARGO_APPS[@]}"; do
        cargo install "$APP" || { echo "Failed to install $APP"; exit 1; }
    done

    echo "All Rust applications installed successfully!"
}

read -p "Install rust apps? (bandwhich, oxipng, presenterm, etc...) [y/n]: " RUST_CHOICE
if [[ $RUST_CHOICE == 'y' ]]; then
    INSTALL_RUST_APPS
fi

# =========================================================================== #
#                                 INSTALL TGPT                                #
# =========================================================================== #

INSTALL_TGPT() {
    curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin
}

read -p "Install tgpt app? (LLM TUI app without APIs) [y/n]: " TGPT_CHOICE
if [[ $TGPT_CHOICE == 'y' ]]; then
    INSTALL_TGPT
fi

# =========================================================================== #
#                                INSTALL TERMV                                #
# =========================================================================== #

INSTALL_TERMV() {
    echo -e "\033[36m| --- 📥 (⊙ _ ⊙ ) Downloading & Installing termv 📥 --- |\033[0m"
    cd "$GIT_STUFF" || exit
    git clone https://github.com/Roshan-R/termv.git
    cd termv || exit
    sudo make install
    cd "$HOME" || exit
}

read -p "Install termv app? (IPTV TUI app played through MPV) [y/n]: " TERMV_CHOICE
if [[ $TERMV_CHOICE == 'y' ]]; then
    INSTALL_TERMV
fi

# =========================================================================== #
#                              INSTALL GLOW & VHS                             #
# =========================================================================== #

INSTALL_CHARM_STUFF() {
    echo -e "\033[36m| --- 📥 (⊙ _ ⊙ ) Downloading & Installing glow 📥 --- |\033[0m"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo nala update && sudo nala install glow vhs
}

read -p "Install Charm terminal apps? (glow, vhs) [y/n]: " CHARM_CHOICE
if [[ $CHARM_CHOICE == 'y' ]]; then
    INSTALL_CHARM_STUFF
fi

# =========================================================================== #
#                                    REAPER                                   #
# =========================================================================== #

INSTALL_REAPER() {
    wget -O reaper.tar.xz http://reaper.fm/files/7.x/reaper758_linux_x86_64.tar.xz
    mkdir ./reaper
    tar -C ./reaper -xf reaper.tar.xz
    ./reaper/reaper_linux_x86_64/install-reaper.sh --install ~/ --integrate-desktop
    rm -rf ./reaper
    rm reaper.tar.xz
    touch ~/REAPER/reaper.ini
}

read -p "Install Reaper DAW? (native install) [y/n]: " REAPER_CHOICE
if [[ $REAPER_CHOICE == 'y' ]]; then
    INSTALL_REAPER
fi

# =========================================================================== #
#                                   SUCCESS!                                  #
# =========================================================================== #

echo -e "🎊 (੭˃ᴗ˂)੭ OOOOOOOOOO YEAHHHHHH!!!"
echo -e "🎉 d-(´▽｀)-b Looks like we're good here"
echo -e "🗘 Restart me now & then we can party!"
