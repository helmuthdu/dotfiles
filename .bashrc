# /etc/bash.bashrc

eval $(dircolors -b ~/.dircolors)

if [ $TERM != 'linux' ]; then

    export TERM='xterm-256color'

    R='\[\e[1;31m\]'
   #G='\[\e[1;32m\]'
    G='\[\e[1;38;5;82m\]'
    Y='\[\e[1;33m\]'
   #B='\[\e[1;34m\]'
    B='\[\e[1;38;5;33m\]'
   LB='\[\e[1;38;5;81m\]'
   #P='\[\e[1;35m\]'
    P='\[\e[1;38;5;140m\]'
    E='\[\e[1;37m\]'
    W='\[\e[0m\]'

    DEV=`tty | /bin/sed -e 's:/dev/pts/::'`

    if [ `id -u` != "0" ]; then
        export PS1="[$P$DEV$W][$LB\u$W][$B\W$W]\$ "
    else
        export PS1="[$P$DEV$W][$R\u$W][$B\W$W]# "
    fi

    #eval $(dircolors -b ~/.dircolors_256)
else
    export TERM='xterm-color'
fi

# Bash completion
complete -cf sudo
set show-all-if-ambiguous on

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

# modified commands
alias ..='cd ..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias free='free -m'                # show sizes in MB
alias grep='grep --color=auto'
alias grep='grep --color=tty -d skip'
alias mkdir='mkdir -p -v'
alias more='less'
alias nano='nano -w'
alias ping='ping -c 5'

# ls
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lm='la | more'

#
## Text Editor.
export EDITOR='vim'
export VISUAL='vim'

#
## Arch Aliases.
alias pacman.upgrade='sudo pacman-color -Syu'
alias pacman.install='sudo pacman-color -S'
alias pacman.clean="sudo pacman-color -Sc --noconfirm"
alias pacman.remove='sudo pacman-color -Rnsc'
alias pacman.unlock='sudo rm -fv /var/lib/pacman/db.lck'
alias packer.install='packer -S --noedit --skipinteg'
alias packer.upgrade='packer -Syu --noconfirm'
alias yaourt.install='yaourt -S --noconfirm'
alias yaourt.upgrade='yaourt -Syua --noconfirm'

#
## Download and Compile packages from aur.
function yaourtd() {
    cd $HOME/Build && yaourt -d "$1" && cd "$_" && makepkg -i;
}

#
## Copy/Move Destiny
function goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }

#
## Nice mount output.
function nmount() {
    (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t;
}

#
## Top 10 Commands.
function top10() {
    # copyright 2007 - 2010 Christopher Bratusek
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

#
## RTFM (Read The Fucking Manual!).
function rtfm() { help $@ || man $@ || lynx "http://www.google.com/search?q=$@"; }

#
## Screenshot.
function shot() {
    import -frame -strip -quality 75 "$HOME/$(date +%s).png"
}

#
## Zip Files.
function zipf() { zip -r "$1".zip "$1" ; }

## Archive extractor.
## usage: ex <file>
#
function extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1
        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi
        case $i in
        *.tar.bz2 ) tar xvjf $1 ;;
         *.tar.gz ) tar xvzf $1 ;;
         *.tar.xz ) tar xvJf $1 ;;
            *.tar ) tar xvf $1 ;;
           *.tbz2 ) tar xvjf $1 ;;
            *.tgz ) tar xvzf $1 ;;
            *.rar ) unrar x $1 ;;
             *.gz ) gunzip $1 ;;
            *.bz2 ) bunzip2 $1 ;;
            *.zip ) unzip $1 ;;
              *.Z ) uncompress $1 ;;
             *.7z ) 7z x $1 ;;
             *.xz ) unxz $1 ;;
            *.exe ) cabextract $1 ;;
                * ) echo "$0: unrecognized file extension: \`$i'" >&2
            continue;;
        esac
        command $c "$i"
        e=$?З
    done
    return $e
}

function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
