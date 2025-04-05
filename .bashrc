#[ -f $HOME/.bashrc  ] && . $HOME/.profile

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export TERM="xterm-256color"                      # getting proper colors

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# custom prompt
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]┌─\[$(tput setaf 7)\]󰅂 \[$(tput setaf 3)\]  \[$(tput setaf 3)\]\h 󰍟 \[$(tput setaf 2)\]󰙃 \[$(tput setaf 2)\]\u 󰍟 \[$(tput setaf 4)\]  \w \[$(tput setaf 1)\]\n└──\[$(tput setaf 7)\]󰅂 \[$(tput setaf 2)\]\\$ \[$(tput sgr0)\]"

# environment variables added here since loading .profile does not work
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.local/bin:$HOME/.local/share/applications:$HOME/.cargo/bin:/var/lib/flatpak/exports/share:/usr/local/lib"

# enable zoxide
eval "$(zoxide init bash)"

# more environment variables
export COLOR_SCHEME="prefer-dark"
export BAT_THEME="gruvbox-dark"

# xdg stuff
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# add truecolor support for the micro text editor
export MICRO_TRUECOLOR="1"

# set doom wads directory
export DOOMWADDIR="$HOME/.wads"

# set fzf defaults
export FZF_DEFAULT_OPTS="--layout=reverse-list --exact --border=bold --border=rounded --margin=1% --color=dark"

# color man and less
export LESS='-R --use-color -Dd+r$Du+b'
export MANPAGER="/usr/bin/less -R --use-color -Dd+r -Du+b"
export LESS_TERMCAP_mb=$'\E[01;31m'             # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'             # begin bold
export LESS_TERMCAP_me=$'\E[0m'                 # end mode
export LESS_TERMCAP_se=$'\E[0m'                 # end standout-mode                 
export LESS_TERMCAP_so=$'\E[01;44;33m'          # begin standout-mode - info box                              
export LESS_TERMCAP_ue=$'\E[0m'                 # end underline
export LESS_TERMCAP_us=$'\E[01;32m'             # begin underline

# print fastfetch upon opening the terminal
fastfetch --config pusheen
