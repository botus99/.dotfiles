#!/bin/bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/OpenDyslexic.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "OpenDyslexic.tar.xz" \
&& rm "OpenDyslexic.tar.xz" \
&& fc-cache -fv
