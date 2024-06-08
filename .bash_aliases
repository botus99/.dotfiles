# update my goods
alias sa="figlet -tf miniwi 'Debian upgrades' \
&& sudo nala update \
&& sudo nala upgrade -y \
&& figlet -tf miniwi 'Flatpak upgrades' \
&& sudo flatpak update -y \
&& figlet -tf miniwi 'Python upgrades' \
&& pipx upgrade-all \
&& figlet -tf miniwi 'Cargo upgrades' \
&& cargo-install-update install-update --all \
&& figlet -tf miniwi 'TLDR upgrades' \
&& tldr -u \
&& figlet -tf miniwi 'TGPT upgrades' \
&& tgpt -u \
&& figlet -tf miniwi 'Garbage removal' \
&& sudo nala autoremove \
&& sudo nala clean \
&& figlet -tf miniwi 'All done!' \
&& echo 'That was nice, thanks for bringing me up to date!'"

# colorize output
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# replace 'ps' with 'procs'
alias ps='procs'

# replace 'cd' with 'z'
alias cd='z'

# replace 'bat' with 'batcat'
alias bat='batcat'

# make cmatrix look how I like
alias cmatrix='cmatrix -asb -u 1 -C red'

# make yabridgectl easier to type 
alias yabridgectl='~/.local/share/yabridge/yabridgectl'

# replace 'ls' with 'eza'
alias ls='eza --header --git --color=always --icons=always --group-directories-first'
alias la='eza --header --git --color=always --icons=always --group-directories-first --all'
alias ll='eza --header --git --color=always --icons=always --group-directories-first --all --long'
alias l='eza --header --git  --color=always --icons=always --group-directories-first --classify=auto'

# readable output
alias df='df -h'

# file owner fixes
alias fix-permissions='sudo chown -R $USER:$USER ~/.config ~/.local'

# archive extractor
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1     ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1     ;;
             *.rar)       rar x $1       ;;
             *.gz)        gunzip $1      ;;
             *.tar)       tar xf $1      ;;
             *.tbz2)      tar xjf $1     ;;
             *.tgz)       tar xzf $1     ;;
             *.zip)       unzip $1       ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# copy files with a progress bar
alias cpv='rsync -ah --info=progress2'

# automatically create nessesary parent directories
alias mkdir="mkdir -p"

# automatically continue interrupted downloads with wget
alias wget="wget -c"

# tell me my external IP addrress
alias myip="curl http://ipecho.net/plain; echo"

# create and enter directory
mcd () {
    mkdir -p $1
    cd $1
}

# change directories easily
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# folders sorted by size
alias foldersizesort='du -sh * |sort -h'

# make downloaded fonts available for all users
alias fonts-copy='sudo cp -r ~/fonts/* /usr/share/fonts/'

# open the kitty theme selector
alias kitty-themes='kitty +kitten themes'
