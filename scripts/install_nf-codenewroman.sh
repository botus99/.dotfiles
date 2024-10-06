#!/usr/bin/env bash

mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CodeNewRoman.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "CodeNewRoman.tar.xz" \
&& rm "CodeNewRoman.tar.xz" \
&& fc-cache -fv
