#!/usr/bin/env bash

# This script combines different repos of shaders 
# for picom from github. It works, but someday I 
# should add error-checking and use git to 
# combine the repos instead of cp. Maybe later.

# More repos to try/add later...
# https://github.com/kin-fuyuki/picom

# Set variables
GH="https://github.com"
REPO="picom-shaders"
FORKS=(mTvare6 ikz87)

# Change directory to /usr/share/
cd /usr/share/ || exit 1

# Create picom-shaders directory
mkdir -p "/usr/share/$REPO"

# Function to clone and rename repos
combine_repo() {
    local FULL_URL="${GH}/${1}/${REPO}"
    git clone "$FULL_URL" "${REPO}-${1}"
    cp -r -f -v "${REPO}-${1}/"* "${REPO}"
}

# Clone, combine, and cleanup repos
for VERSION in "${FORKS[@]}"; do
    combine_repo "$VERSION"
    rm -rf "/usr/share/${REPO}-${VERSION}"
done

# Define extra shader URLs array
URLS=(
    "https://github.com/SwayLE3/picom-shader-oldCRT-Bloom/raw/refs/heads/main/MixedShader.glsl"
    "https://github.com/dedenholm/Chromab-Glitch-GLSL-/raw/refs/heads/main/Chromab-Glitch.glsl"
    "https://github.com/PickNicko13/picom-o8dither/raw/refs/heads/main/fadeDither4x1.glsl"
    "https://github.com/PickNicko13/picom-o8dither/raw/refs/heads/main/fadeDither4x2.glsl"
    "https://github.com/PickNicko13/picom-o8dither/raw/refs/heads/main/fadeDither4x3.glsl"
    "https://github.com/PickNicko13/picom-o8dither/raw/refs/heads/main/fakeDither.glsl"
    "https://github.com/PickNicko13/picom-o8dither/raw/refs/heads/main/halfFakeDither.glsl"
    "https://github.com/4194304/color-depth-shaders/raw/refs/heads/main/256color.glsl"
    "https://github.com/4194304/color-depth-shaders/raw/refs/heads/main/ega.glsl"
    "https://github.com/4194304/color-depth-shaders/raw/refs/heads/main/monochrome_dither.glsl"
    "https://github.com/4194304/color-depth-shaders/raw/refs/heads/main/monochrome_posturize.glsl"
    "https://github.com/4194304/color-depth-shaders/raw/refs/heads/main/vga.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/75.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/75_b.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/basic_posterize.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/bayer.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/bayer_ok.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/bayer_sobel.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/bw.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/dither.glsl"
    "https://github.com/tphLatte/picomShaders/raw/refs/heads/main/dither_sobel.glsl"
    "https://github.com/DiKetarogg/picom-transparent-bg-shader/raw/refs/heads/master/corners-transparent.glsl"
)

# Download GLSL files
for URL in "${URLS[@]}"; do
    FILENAME=$(basename "$URL")
    DEST="/usr/share/${REPO}/${FILENAME}"

    wget \
        --output-document="$DEST" \
        --quiet \
        --no-clobber \
        --progress=bar \
        --show-progress \
        "$URL"
done

# Success message
echo "$REPO installation complete."
