#!/usr/bin/env bash

# STAGING
### Define the source and destination directories
old_dir="$HOME/.git-stuff/Meter"
src_zip="$HOME/.git-stuff/Meter-latest.zip"
dest_dir="$HOME/.git-stuff"

### Fetch the releases page
releases_page=$(curl --silent "https://api.github.com/repos/airwindows/Meter/releases/latest")
latest_release=$(curl --silent "https://api.github.com/repos/airwindows/Meter/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

### Extract the download URL of the latest release asset
latest_release_url=$(echo "$releases_page" | jq -r '.assets[0].browser_download_url')

### Create the destination directory if it doesn't already exist
mkdir -p "$dest_dir"

### Check if the directory already exists
if [ -d "$old_dir" ]; then
    # If the directory exists, delete it
    rm -rf "$old_dir"
    echo "Old Meter version deleted successfully."
fi

### Check if the source zip exists
if [ ! -f "$src_zip" ]; then
    echo "Source file does not exist: $src_zip"
fi

# DOWNLOAD METER
### Download the latest release
curl -L "$latest_release_url" -o "$src_zip"
echo "Downloaded latest Meter release successfully."

### Extract the zip file to the destination directory
unzip "$src_zip" -d "$old_dir"
mv --force --verbose "$old_dir/CLAP/Meter.clap" "$HOME/.clap"
mv --force --verbose "$old_dir/Standalone/Meter" "$HOME/.local/bin"
echo "New Meter release extracted successfully."

### Remove downloaded zip file
rm -v "$src_zip"
rm -rfv "$old_dir/CLAP"
rm -rfv "$old_dir/VST3"
rm -rfv "$old_dir/Standalone"
echo "Cleanup performed successfully"
echo "Installation complete"
