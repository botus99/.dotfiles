#!/usr/bin/env bash

### dotfile installation
cd ~
echo -e "\033[36m 📥 (⊙ _ ⊙ ) Downloading Dotfiles 📥 \033[0m"
git clone https://github.com/botus99/.dotfiles.git
echo -e "\033[36m 🛠️ ٩(ˊᗜˋ*)و Installing Dotfiles 🛠️ \033[0m"
ln -s $HOME/.dotfiles/.config/alacritty ~/.config
ln -s $HOME/.dotfiles/.config/btop ~/.config
ln -s $HOME/.dotfiles/.config/cava ~/.config
ln -s $HOME/.dotfiles/.config/fastfetch ~/.config
ln -s $HOME/.dotfiles/.config/glow ~/.config
ln -s $HOME/.dotfiles/.config/gtk-3.0 ~/.config
ln -s $HOME/.dotfiles/.config/gtk-4.0 ~/.config
ln -s $HOME/.dotfiles/.config/kitty ~/.config
ln -s $HOME/.dotfiles/.config/Kvantum ~/.config
ln -s $HOME/.dotfiles/.config/micro ~/.config
ln -s $HOME/.dotfiles/.config/mpd ~/.config
ln -s $HOME/.dotfiles/.config/mpv ~/.config
ln -s $HOME/.dotfiles/.config/ncmpcpp ~/.config
ln -s $HOME/.dotfiles/.config/nwg-look ~/.config
ln -s $HOME/.dotfiles/.config/pcmanfm ~/.config
ln -s $HOME/.dotfiles/.config/polybar ~/.config
ln -s $HOME/.dotfiles/.config/qt5ct ~/.config
ln -s $HOME/.dotfiles/.config/qt6ct ~/.config
ln -s $HOME/.dotfiles/.config/rofi ~/.config
ln -s $HOME/.dotfiles/.config/uzdoom ~/.config
ln -s $HOME/.dotfiles/.config/xsettingsd ~/.config

### success message
echo -e "🎉 (੭˃ᴗ˂)੭ GREAT SUCCESS!!! WE DID IT!!! "
echo -e "🎊 d-(´▽｀)-b Looks like we're good here "
echo -e "Hope you like my dotfiles. Enjoy! "
