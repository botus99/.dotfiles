#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[1;31m|-----------------------------------------------------------------|\033[0m"
  echo -e "\033[1;31m|  ( •̀ - •́ )     You must run this script as root!    ( •̀ - •́ )   |\033[0m"
  echo -e "\033[1;31m|  ¯\_(ツ)_/¯    ...or maybe sudo or something???     ¯\_(ツ)_/¯  |\033[0m"
  echo -e "\033[1;31m|-----------------------------------------------------------------|\033[0m"
  exit 1
fi

# Get the Debian version
debian_version=$(cat /etc/debian_version)

# Check if the version contains "Bookworm"
if [[ $debian_version == *"Bookworm"* ]]; then
    echo "You are using Debian Bookworm!"
    # Backup current sources.list
    echo -e "\033[1;32m|------------------------------------------------------------------|\033[0m"
    echo -e "\033[1;32m|  d-(´▽｀)-b    Backing up current sources.list...  ৻(  •̀ ᗜ •́  ৻)  |\033[0m"
    sudo cp -i /etc/apt/sources.list /etc/apt/sources.list.old
    echo -e "\033[1;32m|  d-(´▽｀)-b    Backup saved to sources.list.old!   ৻(  •̀ ᗜ •́  ৻)  |\033[0m"
    echo -e "\033[1;32m|------------------------------------------------------------------|\033[0m"
    
    # Update apt sources list
    echo "deb http://deb.debian.org/debian/ testing main contrib non-free-firmware non-free" | sudo tee /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian/ testing main contrib non-free-firmware non-free" | sudo tee -a /etc/apt/sources.list
    
    echo "deb http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list

    echo "deb http://deb.debian.org/debian/ testing-updates main contrib non-free-firmware non-free" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free-firmware non-free" | sudo tee -a /etc/apt/sources.list

    echo "deb http://deb.debian.org/debian/ testing-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian/ testing-backports main non-free-firmware" | sudo tee -a /etc/apt/sources.list
    
    # Update package lists
    sudo nala update
    sudo nala full-upgrade
    sudo nala autoremove
    
    # Say goodbye
    echo -e "\033[1;32m|-------------------------------------------------------------------------|\033[0m"
    echo -e "\033[1;32m|  d-(´▽｀)-b  Debian Testing repositories added successfully. d-(´▽｀)-b  |\033[0m"
    echo -e "\033[1;32m|  (ง ◉ _ ◉)ง    ...so uhh, now what are you gonna do to me?   (ง ◉ _ ◉)ง  |\033[0m"
    echo -e "\033[1;32m|-------------------------------------------------------------------------|\033[0m"
else
    # Tell the user to pound sand for trying to break their system
    echo -e "\033[1;31m|-------------------------------------------------------------------------|\033[0m"
    echo -e "\033[1;31m|  ( •̀ - •́ )   You are not using Debian Bookworm. For shame!   ( •̀ - •́ )  |\033[0m"
    echo -e "\033[1;31m|  (ᴗ_ ᴗ。)    Go away & think about what you are doing here!   (ᴗ_ ᴗ。)  |\033[0m"
    echo -e "\033[1;31m|-------------------------------------------------------------------------|\033[0m"
fi
