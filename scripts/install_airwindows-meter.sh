#!/usr/bin/env bash

# Airwindows plugins are a gift to humanity from Chris Johnson
# Usually, you can bulk download all his plugins from his site, but Meter is different
# This script installs the newesst Meter plugin in your chosen format (CLAP, VST3, Standalone)
# If you work with audio, you owe it to yourself to check out Airwindows!!!
#
# I'm sure that I can make this better, but it works for now

# =========================================================================== #
#                                   STAGING                                   #
# =========================================================================== #

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Define the source and destination directories
OLD_DIR="$HOME/.git-stuff/Meter"
SRC_ZIP="$HOME/.git-stuff/Meter-latest.zip"
DEST_DIR="$HOME/.git-stuff"

# Create error message
ERROR_MESSAGE() {
    echo -e "${RED}Error:${RESET} $1"
}

# Fetch the releases page
RELEASES_PAGE=$(curl --silent "https://api.github.com/repos/airwindows/Meter/releases/latest")
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/airwindows/Meter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Extract the download URL of the latest release asset
LATEST_RELEASE_URL=$(echo "${RELEASES_PAGE}" | jq -r '.assets[0].browser_download_url')

# Ensure that the destination directory exists
mkdir -p "${DEST_DIR}" &>/dev/null

# =========================================================================== #
#                                DOWNLOAD METER                               #
# =========================================================================== #

DOWNLOAD_LATEST_RELEASE() {
    echo -e "${RESET}------------------------------------------------------------${RESET}"
    echo -e "${BLUE}⬇️ Downloading latest Airwindows Meter release${RESET}"
    echo -e "${RESET}------------------------------------------------------------${RESET}"
    if ! curl -L "${LATEST_RELEASE_URL}" -o "${SRC_ZIP}"; then
        ERROR_MESSAGE "Failed to download the latest Meter release"
        echo -e "${RED}Please check your network connection and try again.${RESET}"
        exit 1
    fi
    echo -e "${RESET}------------------------------------------------------------${RESET}"
    echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} downloaded successfully${RESET}"
    echo -e "${RESET}------------------------------------------------------------${RESET}"
}
DOWNLOAD_LATEST_RELEASE

BACKUP_CURRENT_RELEASE() {
    if [ -d "${OLD_DIR}" ]; then
        mv --force --verbose "${OLD_DIR}" "${OLD_DIR}-bak"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${YELLOW}🗄️ Current Meter release backed up successfully${RESET}"
        echo -e "${YELLOW}🗄️ Backed up to - ${RESET}${OLD_DIR}-bak${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    fi
}
BACKUP_CURRENT_RELEASE

UNZIP_RELEASE() {
    if ! unzip -o "${SRC_ZIP}" -d "${OLD_DIR}"; then
        ERROR_MESSAGE "Failed to extract ${SRC_ZIP}"
        exit 1
    fi
    echo -e "${RESET}------------------------------------------------------------${RESET}"
    echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} extracted sucessfully${RESET}"
    echo -e "${YELLOW}👽️ Extracted to - ${RESET}${OLD_DIR}${RESET}"
    echo -e "${RESET}------------------------------------------------------------${RESET}"
}
UNZIP_RELEASE

# =========================================================================== #
#                             CHOOSE PLUGIN FORMAT                            #
# =========================================================================== #

INSTALL_CLAP() {
    read -r -p "Do you want to install CLAP? (y/n): " CLAP_CHOICE
    if [[ ${CLAP_CHOICE} == "y" ]]; then
        mkdir -p "${HOME}/.clap" &>/dev/null
        mv --force --verbose "${OLD_DIR}/CLAP/Meter.clap" "${HOME}/.clap"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} CLAP installed successfully${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    elif  [[ ${CLAP_CHOICE} == "n" ]]; then
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${YELLOW}🤷 Okay, guess you are more of a VST person then...${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    fi
}
INSTALL_CLAP

INSTALL_VST3() {
    read -r -p "Do you want to install VST3? (y/n): " VST3_CHOICE
    if [[ ${VST3_CHOICE} == "y" ]]; then
        mkdir -p "${HOME}/.vst3" &>/dev/null
        mv --force --verbose "${OLD_DIR}/VST3/Meter.vst3/Contents/x86_64-linux/Meter.so" "${HOME}/.vst3"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} VST3 installed successfully${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    elif  [[ ${VST3_CHOICE} == "n" ]]; then
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${YELLOW}🤷 Fine, maybe you don't like Steinberg then...${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    fi
}
INSTALL_VST3

INSTALL_STANDALONE() {
read -r -p "Do you want to install Standalone? (y/n): " STANDALONE_CHOICE
    if [[ ${STANDALONE_CHOICE} == "y" ]]; then
        mkdir -p "${HOME}/.local/bin" &>/dev/null
        mv --force --verbose "${OLD_DIR}/Standalone/Meter" "${HOME}/.local/bin"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} Standalone installed successfully${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    elif  [[ ${STANDALONE_CHOICE} == "n" ]]; then
        echo -e "${RESET}------------------------------------------------------------${RESET}"
        echo -e "${YELLOW}🤷 Well, I hope you picked one of the first ones!${RESET}"
        echo -e "${RESET}------------------------------------------------------------${RESET}"
    fi
}
INSTALL_STANDALONE

CLEANUP() {
    rm -v "${SRC_ZIP}"
    #rm -rfv "${OLD_DIR}/CLAP"
    #rm -rfv "${OLD_DIR}/VST3"
    #rm -rfv "${OLD_DIR}/Standalone"
    echo -e "${RESET}------------------------------------------------------------${RESET}"
    echo -e "${GREEN}🧹 Cleanup performed successfully${RESET}"
    echo -e "${GREEN}✅ Meter ${LATEST_RELEASE} installation complete${RESET}"
    echo -e "${RESET}------------------------------------------------------------${RESET}"
}
CLEANUP