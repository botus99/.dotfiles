#!/bin/bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "CascadiaCode.tar.xz" \
&& rm "CascadiaCode.tar.xz" \
&& fc-cache -fv
