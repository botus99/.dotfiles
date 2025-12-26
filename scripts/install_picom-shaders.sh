#!/usr/bin/env bash

# This is a basic script to combine two different
# picom-shaders repos from github. It works, but
# someday I should add error-checking and use git
# to combine the repos instead of cp. Not today.

# Set variables
GH="https://github.com"
REPO="picom-shaders"
FORKS=(mTvare6 ikz87)

# Change directory to /usr/share/
cd /usr/share/ || exit 1

# Create picom-shaders directory
mkdir -p "/usr/share/$REPO"

# Function to clone and rename repositories
combine_repo() {
    local FULL_URL="${GH}/${1}/${REPO}"
    git clone "$FULL_URL" "${REPO}-${1}"
    cp -r -f -v "${REPO}-${1}/"* "${REPO}"
}

# Clone and combine different versions
for VERSION in "${FORKS[@]}"; do
    combine_repo "$VERSION"
    rm -rf "/usr/share/${REPO}-${VERSION}"
done

# Success message
echo "$REPO installation complete."
