#[ -f $HOME/.bashrc  ] && . $HOME/.profile

# ============================================================================
# SHELL OPTIONS
# ============================================================================

# ble.sh
# standard streams (stdin, stdout, and stderr) should not be redirected
# but should be connected to the controlling TTY of the current session.
# Also, please avoid calling source -- /path/to/ble.sh in shell functions.
# More at bottom of script...
# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Disable ctrl-s and ctrl-q (terminal pause)
stty -ixon

# enable zoxide
eval "$(zoxide init bash)"

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

shopt -s histappend         # append to the history file, don't overwrite it
shopt -s checkwinsize       # update LINES and COLUMNS values for the window size after each command
shopt -s globstar           # Allow ** for recursive matching
shopt -s nocaseglob         # Case-insensitive globbing
shopt -s extglob            # Extended pattern matching
shopt -s cdspell            # Spellcheck directories when using cd

# don't add duplicate lines or lines starting with space to the history file
export HISTCONTROL=ignoreboth:erasedups
# ignore given commands for bash history
export HISTIGNORE="?:??:pwd:exit:clear:history:...:...."
export HISTFILESIZE=20000   # define maximum number of total lines
export HISTSIZE=10000       # define maximum number of stored commands

# Immediately write history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# ============================================================================
# ALIASES
# ============================================================================

# Source external bash aliases file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ============================================================================
# COMPLETION
# ============================================================================

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Git completion
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi


# ============================================================================
# PROMPT
# ============================================================================

# custom prompt
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]┌─\[$(tput setaf 7)\]󰅂 \[$(tput setaf 3)\]  \[$(tput setaf 3)\][\h] 󰍟 \[$(tput setaf 2)\]󰙃 \[$(tput setaf 2)\][\u] 󰍟 \[$(tput setaf 4)\]  [\w] 󰍟 \[$(tput setaf 8)\] \[$(tput setaf 15)\][\t] \[$(tput setaf 1)\]\n└──\[$(tput setaf 7)\]󰅂 \[$(tput setaf 2)\]\\$ \[$(tput sgr0)\]"


# ============================================================================
# PATH
# ============================================================================

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:\
$HOME/.local/bin:$HOME/.local/bin/statusbar:$HOME/.local/share/applications:\
$HOME/.cargo/bin:\
$HOME/AppImages:\
/var/lib/flatpak/exports/share:\
/usr/local/lib"

# set doom wads directory
export DOOMWADDIR="$HOME/.wads"

# fix non-standard location of libvapoursynth-script.so.0 for vapoursynth
#export LD_LIBRARY_PATH="/usr/local/lib vspipe --version"


# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# xdg stuff
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"


# ============================================================================
# THEMING
# ============================================================================

export BAT_THEME="gruvbox-dark"
export COLOR_SCHEME="prefer-dark"
export FONT="Mononoki Nerd Font 9"
export FZF_DEFAULT_OPTS="--layout=reverse-list --exact --border=bold --border=rounded --margin=1% --color=dark"
export GTK_THEME="Colloid-Red-Dark-Compact-Gruvbox"
export ICON_THEME="Papirus"
export MICRO_TRUECOLOR="1"
export XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons"

# Colored man pages
#export MANPAGER="/usr/bin/less -R --use-color -Dd+r$Du+b "
export MANPAGER="/usr/bin/batcat -l man --plain --color always"
export LESS_TERMCAP_mb=$'\e[1;31m'             # begin blinking
export LESS_TERMCAP_md=$'\e[1;31m'             # begin bold
export LESS_TERMCAP_me=$'\e[0m'                # end mode
export LESS_TERMCAP_se=$'\e[0m'                # end standout-mode
export LESS_TERMCAP_so=$'\e[01;33m'            # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'                # end underline
export LESS_TERMCAP_us=$'\e[1;4;31m'           # begin underline

# Better less defaults
#export LESS="-R --use-color -Dd+r$Du+b "
export LESS='-R -F -X -i -P %f (%i/%m) '
export LESSHISTFILE=/dev/null

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export TERM="xterm-256color"


# ============================================================================
# WELCOME MESSAGE
# ============================================================================

fastfetch --config pusheen


# ============================================================================
# ble.sh
# ============================================================================

# Add this line at the end of .bashrc:
[[ ! ${BLE_VERSION-} ]] || ble-attach