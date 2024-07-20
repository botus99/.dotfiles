#!/bin/bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "DejaVuSansMono.tar.xz" \
&& rm "DejaVuSansMono.tar.xz" \
&& fc-cache -fv
