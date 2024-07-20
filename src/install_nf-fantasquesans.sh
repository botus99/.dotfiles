#!/usr/bin/env bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FantasqueSansMono.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "FantasqueSansMono.tar.xz" \
&& rm "FantasqueSansMono.tar.xz" \
&& fc-cache -fv
