#!/bin/bash
mkdir -p "$HOME/.local/share/fonts/NerdFonts" \
&& wget -P "$HOME/.local/share/fonts/NerdFonts" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.tar.xz" \
&& cd "$HOME/.local/share/fonts/NerdFonts" \
&& tar -xf "Iosevka.tar.xz" \
&& rm "Iosevka.tar.xz" \
&& fc-cache -fv
