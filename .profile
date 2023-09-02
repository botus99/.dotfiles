# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

export GTK_THEME_NAME="Matcha-dark-aliz"
export ICON_THEME_NAME="Vimix Ruby dark"
export CURSOR_THEME_NAME="ArcDusk-cursors"
export FONT_NAME="Iosevka 10"
export FONT_NAME="Mononoki 10"
export COLOR_SCHEME="prefer-dark"
#export QT_STYLE_OVERRIDE="kvantum-dark"
#export QT_QPA_PLATFORMTHEME="qt6ct"

# Created by `pipx` on 2023-02-05 18:07:48
#export PATH="$HOME/.local/bin:PATH"
#export PATH="$HOME/.cargo/bin:PATH"
