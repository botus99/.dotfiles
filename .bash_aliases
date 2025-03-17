# update my goods
alias sa="figlet -tf miniwi 'Debian upgrades' \
&& sudo nala upgrade -y \
&& figlet -tf miniwi 'Deb-Get upgrades' \
&& sudo deb-get update --repos-only \
&& sudo deb-get upgrade \
&& figlet -tf miniwi 'Flatpak upgrades' \
&& flatpak update -y \
&& figlet -tf miniwi 'Python upgrades' \
&& pipx upgrade-all \
&& figlet -tf miniwi 'Cargo upgrades' \
&& cargo-install-update install-update --all \
&& figlet -tf miniwi 'TLDR upgrades' \
&& tldr -u \
&& figlet -tf miniwi 'TGPT upgrades' \
&& sudo tgpt -u \
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
    set -e  # abort execution on errors

    if [ $# -eq 0 ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"

        return 1
    fi

    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar --auto-compress -xvf "$n" ;;
            *.lzma)      unlzma "$n" ;;
            *.bz2)       bunzip2 "$n" ;;
            *.cbr|*.rar) unrar x -ad "$n" ;;
            *.gz)        gunzip "$n" ;;
            *.cbz|*.epub|*.zip) unzip "$n" ;;
            *.z)         uncompress "$n" ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                         7z x "$n" ;;
            *.xz)        unxz "$n" ;;
            *.exe)       cabextract "$n" ;;
            *.cpio)      cpio -id < "$n" ;;
            *.cba|*.ace) unace x "$n" ;;
            *.zpaq)      zpaq x "$n" ;;
            *.arc)       arc e "$n" ;;
            *.cso)       ciso 0 "$n" "$n.iso" && extract "$n.iso" && rm -f "$n" ;;
            *.zlib)      zlib-flate -uncompress < "$n" > "${n%.*zlib}" && rm -f "$n" ;;
            *.dmg)
                         mnt_dir=$(mktemp -d)
                         hdiutil mount "$n" -mountpoint "$mnt_dir"
                         echo "Mounted at: $mnt_dir" ;;
            *.tar.zst)  tar -I zstd -xvf "$n" ;;
            *.zst)      zstd -d "$n" ;;
            *)
                echo "extract: '$n' - unknown archive method"
                continue ;;
        esac
    done
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

# display image in terminal
alias kitty-pix='kitty +kitten icat'

# make bro use specified theme
alias bro='bro --theme gruvbox-dark'

# make cbonsai use my preferred settings
alias cbonsai='cbonsai --multiplier 15 --life 100 -S'

# make ncmpcpp launch as a session in kitty
alias ncmpcpp='kitty -o font_size=11 --session ~/.config/kitty/ncmpcpp.session'

# make getting weather forecasts easier
alias weather='curl wttr.in'

# edit nextcloud php config
alias nextcloud-config='micro /nextcloud/config/www/nextcloud/config/config.php'
