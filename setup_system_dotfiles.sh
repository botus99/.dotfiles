#!/usr/bin/env bash

### dotfile installation
cd ~ || exit
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Dotfiles 📥 \033[0m"
git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Installing Dotfiles 🛠️ \033[0m"
ln -sf "$HOME/.dotfiles/.config/alacritty" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/autostart" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/btop" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/cava" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/fastfetch" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/glow" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/gtk-3.0" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/gtk-4.0" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/jgmenu" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/kitty" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/Kvantum" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/micro" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/mpd" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/mpDris2" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/mpv" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/MusicBrainz" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/ncmpcpp" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/nwg-look" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/pcmanfm" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/polybar" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/qt5ct" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/qt6ct" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/rofi" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/suckless" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/uzdoom" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/wal" "$HOME/.config"
ln -sf "$HOME/.dotfiles/.config/xsettingsd" "$HOME/.config"

### success message
echo -e "🎉 (੭˃ᴗ˂)੭ GREAT SUCCESS!!! WE DID IT!!! "
echo -e "🎊 d-(´▽｀)-b Looks like we're good here "
echo -e "Hope you like my dotfiles. Enjoy! "
