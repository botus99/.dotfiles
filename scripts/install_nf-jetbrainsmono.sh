#!/usr/bin/env bash

mkdir -p "$HOME/.local/share/fonts/NerdFonts"
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
cd "$HOME/.local/share/fonts/NerdFonts"
tar -xf "JetBrainsMono.tar.xz"
rm "JetBrainsMono.tar.xz"
fc-cache -fv
