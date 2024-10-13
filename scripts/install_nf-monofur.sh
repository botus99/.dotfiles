#!/usr/bin/env bash

mkdir -p "$HOME/.local/share/fonts/NerdFonts"
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monofur.tar.xz"
cd "$HOME/.local/share/fonts/NerdFonts"
tar -xf "Monofur.tar.xz"
rm "Monofur.tar.xz"
fc-cache -fv
