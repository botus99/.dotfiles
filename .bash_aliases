# update my goods
alias sa="colorscript -e crunchbang-mini && echo 'Time to upgrade your system? Ok, here goes nothing!' && figlet -tcf smslant 'Debian upgrades' && colorscript -e debian && sudo nala update && sudo nala upgrade -y && figlet -tcf smslant 'Flatpak upgrades' && sudo flatpak update -y && colorscript -e ghosts && figlet -tcf smslant 'Python upgrades' && pipx upgrade-all && figlet -tcf smslant 'Garbage removal' && sudo nala autoremove && sudo nala clean && colorscript -e bars && figlet -tcf smslant 'All done!' && echo 'That was nice, thanks for bringing me up to date!'"

# colorize output
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# replace 'ps' with 'procs'
alias ps='procs'

# replace 'bat' with 'batcat'
alias bat='batcat'

# make cmatrix look how I like
alias cmatrix='cmatrix -asb -u 1 -C red'

# make yabridgectl easier to type 
alias yabridgectl='~/.local/share/yabridge/yabridgectl'

# replace 'ls' with 'exa'
alias ls='exa --header --color=always --group-directories-first --icons'
alias ll='exa -al --long --header --color=always --group-directories-first --icons'
alias la='exa -a --header --color=always --group-directories-first --icons'
alias l='exa -CF -header --color=always --group-directories-first --icons'

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
