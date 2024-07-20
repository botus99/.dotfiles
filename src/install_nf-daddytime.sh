#!/usr/bin/env bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DaddyTimeMono.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "DaddyTimeMono.tar.xz" \
&& rm "DaddyTimeMono.tar.xz" \
&& fc-cache -fv
