#/----------------------------------------/
#╱╭━━━╮╱╭╮╱╱╱╱╭━━╮╱╭━━━╮╱╭━━━╮╱╭━━━╮╱╭━━━╮/
#╱┃╭━╮┃╱┃┃╱╱╱╱╰┫┣╯╱┃╭━╮┃╱┃╭━╮┃╱┃╭━━╯╱┃╭━╮┃/
#/┃┃╱┃┃╱┃┃╱╱╱╱╱┃┃╱╱┃┃╱┃┃╱┃╰━━╮╱┃╰━━╮╱┃╰━━╮/
#╱┃╰━╯┃╱┃┃╱╭╮╱╱┃┃╱╱┃╰━╯┃╱╰━━╮┃╱┃╭━━╯╱╰━━╮┃/
#╱┃╭━╮┃╱┃╰━╯┃╱╭┫┣╮╱┃╭━╮┃╱┃╰━╯┃╱┃╰━━╮╱┃╰━╯┃/
#╱╰╯╱╰╯╱╰━━━╯╱╰━━╯╱╰╯╱╰╯╱╰━━━╯╱╰━━━╯╱╰━━━╯/
#/----------------------------------------/

# update my goods
alias sa="figlet -tf miniwi 'Debian upgrades' \
&& sudo nala upgrade -y \
&& figlet -tf miniwi 'Deb-Get upgrades' \
&& sudo deb-get update --repos-only && sudo deb-get upgrade --dg-only \
&& figlet -tf miniwi 'Pacstall upgrades' \
&& pacstall -Up \
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


# ============================================================================
# FILE OPERATIONS
# ============================================================================

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

# copy files with a progress bar
alias cpv='rsync -ah --info=progress2'

# file owner fixes
alias fix-permissions='sudo chown -R $USER:$USER ~/.config ~/.local'

# consolidate downloaded fonts & make available for all users
alias fonts-copy='sudo cp -r ~/.fonts/* /usr/share/fonts/ && sudo cp -r ~/.local/share/fonts/* /usr/share/fonts/'


# ============================================================================
# LS VARIANTS
# ============================================================================

if command -v eza >/dev/null 2>&1; then
    alias l='eza --header --git  --color=always --icons=always --group-directories-first --classify=auto'
    alias ll='eza --header --git --color=always --icons=always --group-directories-first --all --long'
    alias la='eza --header --git --color=always --icons=always --group-directories-first --all'
    alias ls='eza --header --git --color=always --icons=always --group-directories-first'
    alias lt='eza --header --git --color=always --icons=always --tree --level=2 --icons'
    alias lh='eza --header --git --color=always --icons=always -la --sort=modified --reverse'
elif command -v exa >/dev/null 2>&1; then
    alias l='exa -l --color=always --group-directories-first'
    alias ls='exa -a --icons --group-directories-first'
    alias ll='exa -la --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias lt='exa --tree --level=2 --icons'
    alias lh='exa -la --sort=modified --reverse'
else
    alias l='ls -lF'
    alias ll='ls -laF'
    alias la='ls -A'
    alias lt='tree -L 2'
    alias lh='ls -lath'
fi


# ============================================================================
# NAVIGATION
# ============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# replace 'cd' with 'z'
alias cd='z'

# folders sorted by size
alias foldersizesort='du -sh * | sort -h'


# ============================================================================
# PATHS
# ============================================================================

# easy flatpak access
alias codium='flatpak run com.vscodium.codium'
alias gearlever='flatpak run it.mijorus.gearlever'
alias wardrobe='flatpak run io.github.swordpuffin.wardrobe'
alias zed='flatpak run dev.zed.Zed'

# pretty print path
alias path="echo $PATH | tr -s ':' '\n'"


# ============================================================================
# PIPEWIRE
# ============================================================================

alias pw0='pw-metadata -n settings 0 clock.force-quantum 0'
alias pw64='pw-metadata -n settings 0 clock.force-quantum 64'
alias pw128='pw-metadata -n settings 0 clock.force-quantum 128'
alias pw256='pw-metadata -n settings 0 clock.force-quantum 256'
alias pw512='pw-metadata -n settings 0 clock.force-quantum 512'
alias pw1024='pw-metadata -n settings 0 clock.force-quantum 1024'
alias pw2048='pw-metadata -n settings 0 clock.force-quantum 2048'


# ============================================================================
# SYSTEM UTILITIES
# ============================================================================

# add color
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=always'
alias tree='tree --dirsfirst -C'

# replace 'ps' with 'procs'
alias ps='procs'

# replace 'bat' with 'batcat'
alias bat='batcat'

# make cmatrix look how I like
alias cmatrix='cmatrix -asb -u 1 -C red'

# readable output
alias df='df -h'
alias du='du -h'
alias free='free -h'

# tell me my external IP addrress
alias myip='curl http://ipecho.net/plain; echo'

# open the kitty theme selector
alias kitty-themes='kitty +kitten themes'

# display image in terminal
alias kitty-pix='kitty +kitten icat'

# make bro use specified theme
alias bro='bro --theme gruvbox-dark'

# make cbonsai use my preferred settings
alias cbonsai='cbonsai --multiplier 15 --life 100 -S'

# make getting weather forecasts easier
alias weather='curl wttr.in'

# dwm aliases
alias cdwm='micro ~/.config/suckless/dwm/config.def.h'
alias mdwm='cd ~/.config/suckless/dwm; rm config.h; sudo make clean install; cd -'

# edit nextcloud php config
alias nextcloud-config='micro /nextcloud/config/www/nextcloud/config/config.php'

# make ncmpcpp launch as a session in kitty
#alias ncmpcpp='kitty -o font_size=11 --session ~/.config/kitty/ncmpcpp.session'


#/-------------------------------------------------------/
#╱╭━━━╮╱╭╮╱╭╮╱╭━╮╱╭╮╱╭━━━╮╱╭━━━━╮╱╭━━╮╱╭━━━╮╱╭━╮╱╭╮╱╭━━━╮/
#╱┃╭━━╯╱┃┃╱┃┃╱┃┃╰╮┃┃╱┃╭━╮┃╱┃╭╮╭╮┃╱╰┫┣╯╱┃╭━╮┃╱┃┃╰╮┃┃╱┃╭━╮┃/
#╱┃╰━━╮╱┃┃╱┃┃╱┃╭╮╰╯┃╱┃┃╱╰╯╱╰╯┃┃╰╯╱╱┃┃╱╱┃┃╱┃┃╱┃╭╮╰╯┃╱┃╰━━╮/
#╱┃╭━━╯╱┃┃╱┃┃╱┃┃╰╮┃┃╱┃┃╱╭╮╱╱╱┃┃╱╱╱╱┃┃╱╱┃┃╱┃┃╱┃┃╰╮┃┃╱╰━━╮┃/
#╱┃┃╱╱╱╱┃╰━╯┃╱┃┃╱┃┃┃╱┃╰━╯┃╱╱╱┃┃╱╱╱╭┫┣╮╱┃╰━╯┃╱┃┃╱┃┃┃╱┃╰━╯┃/
#╱╰╯╱╱╱╱╰━━━╯╱╰╯╱╰━╯╱╰━━━╯╱╱╱╰╯╱╱╱╰━━╯╱╰━━━╯╱╰╯╱╰━╯╱╰━━━╯/
#/-------------------------------------------------------/

# fzf bash history
fh () {
    eval $(history | fzf --layout=reverse --exact --prompt=" " --no-sort --margin=1% --gap=1 --multi --color="bg+:0,fg:15,fg+:9,border:8,hl+:2,prompt:15,hl:2,pointer:1,info:8,spinner:1" --border --border=bold --border=rounded --border-label="HISTORY" --highlight-line --pointer " " | sed 's/ *[0-9]* *//')
}

# convert markdown to html
md2html() {
  /usr/bin/pandoc --standalone \
    --template=https://raw.githubusercontent.com/tajmone/pandoc-goodies/master/templates/html5/github/GitHub.html5 \
    --highlight-style=pygments \
    --css=https://bootswatch.com/3/lumen/bootstrap.min.css \
    --metadata pagetitle="$1" "$1" -o "${1%.*}.html"
}

# create and enter directory
mcd () {
    mkdir -p $1
    cd $1
}

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
