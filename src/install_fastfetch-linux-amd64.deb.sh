#!/bin/bash

# Define the base URL for the FastFetch releases
BASE_URL="https://github.com/fastfetch-cli/fastfetch/releases"

# Find the latest release
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" | grep '"tag_name":' | sed 's/.*:\s*"\([^"]*\)".*/\1/')

# Construct the download URL
DOWNLOAD_URL="${BASE_URL}/download/${LATEST_RELEASE}/fastfetch-linux-amd64.deb"

# Download the.deb package
echo "Downloading the latest FastFetch.deb package..."
wget "${DOWNLOAD_URL}"

# Prompt the user before installing
read -p "Do you want to install FastFetch now? [y/N] " answer
if [[ $answer =~ ^[Yy]$ ]]
then
    # Install the package using dpkg
    echo "Installing FastFetch..."
    sudo dpkg -i ./fastfetch-linux-amd64.deb
else
    echo "Installation cancelled."
fi

# Clean up the downloaded.deb file
rm ./fastfetch-linux-amd64.deb
