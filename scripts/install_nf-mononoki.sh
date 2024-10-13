#!/usr/bin/env bash

mkdir -p "$HOME/.local/share/fonts/NerdFonts"
wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz"
cd "$HOME/.local/share/fonts/NerdFonts"
tar -xf "Mononoki.tar.xz"
rm "Mononoki.tar.xz"
fc-cache -fv
