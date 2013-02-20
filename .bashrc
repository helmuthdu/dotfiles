# Archlinux Ultimate Install - .bashrc
# by helmuthdu
## OVERALL CONDITIONALS {{{
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true
# }}}
## PS1 CONFIG #{{{
    [[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)
    if $_isxrunning; then

        [[ -f $HOME/.dircolors_256 ]] && eval $(dircolors -b $HOME/.dircolors_256)

        export TERM='xterm-256color'

        B='\[\e[1;38;5;33m\]'
       LB='\[\e[1;38;5;81m\]'
        D='\[\e[1;38;5;242m\]'
        G='\[\e[1;38;5;82m\]'
        P='\[\e[1;38;5;161m\]'
       PP='\[\e[1;38;5;93m\]'
        R='\[\e[1;38;5;196m\]'
        Y='\[\e[1;38;5;214m\]'
        W='\[\e[0m\]'

        if ! $_isroot; then
            export PS1="$D[$Y\u$D($PP$@\l$D)$P\h$W:$B\W$D]$W\$ "
        else
            export PS1="$D[$R\u$D($PP$@\l$D)$P\h$W:$B\W$D]$W# "
        fi
    else
        export TERM='xterm-color'
    fi
#}}}
## BASH OPTIONS #{{{
    shopt -s cdspell                 # Correct cd typos
    shopt -s checkwinsize            # Update windows size on command
    shopt -s histappend              # Append History instead of overwriting file
    shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
    shopt -s extglob                 # Extended pattern
    shopt -s no_empty_cmd_completion # No empty completion
    ## COMPLETION #{{{
    complete -cf sudo
    if [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
    #}}}
#}}}
## EXPORTS #{{{
    export PATH=/usr/local/bin:$PATH
    export EDITOR="vim"
    ## BASH HISTORY #{{{
        # make multiple shells share the same history file
        export HISTSIZE=10000           # bash history will save N commands
        export HISTFILESIZE=${HISTSIZE} # bash will remember N commands
        export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
        export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
    #}}}
    ## COLORED MANUAL PAGES #{{{
    # @see http://www.tuxarena.com/?p=508
    # For colourful man pages (CLUG-Wiki style)
    if $_isxrunning; then
        export PAGER=less
        export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
        export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
        export LESS_TERMCAP_me=$'\E[0m'           # end mode
        export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
        export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
        export LESS_TERMCAP_ue=$'\E[0m'           # end underline
        export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
    fi
    #}}}
#}}}
## ALIAS #{{{
    ## MODIFIED COMMANDS #{{{
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
    #}}}
    ## PRIVILEGED ACCESS #{{{
        if ! $_isroot; then
            alias sudo='sudo '
            alias scat='sudo cat'
            alias svim='sudo vim'
            alias root='sudo su'
            alias reboot='sudo reboot'
            alias halt='sudo halt'
        fi
    #}}}
    ## PACMAN ALIASES (if applicable, replace 'sudo pacman' with 'yaourt') #{{{
        # we're on ARCH
        if $_isarch; then
            # we're not root
            if ! $_isroot; then
                # pacman-color is installed
                if which pacman-color &>/dev/null; then
                    alias pacman='sudo pacman-color'
                # pacman-color not installed
                else
                    alias pacman='sudo pacman'
                fi
            fi
            alias pac="pacman -S"      # default action     - install one or more packages
            alias pacu="pacman -Syu"   # '[u]pdate'         - upgrade all packages to their newest version
            alias pacs="pacman -Ss"    # '[s]earch'         - search for a package using one or more keywords
            alias paci="pacman -Si"    # '[i]nfo'           - show information about a package
            alias pacr="pacman -R"     # '[r]emove'         - uninstall one or more packages
            alias pacl="pacman -Sl"    # '[l]ist'           - list all packages of a repository
            alias pacll="pacman -Qqm"  # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
            alias paclo="pacman -Qdt"  # '[l]ist [o]rphans' - list all packages which are orphaned
            alias paco="pacman -Qo"    # '[o]wner'          - determine which package owns a given file
            alias pacf="pacman -Ql"    # '[f]iles'          - list all files installed by a given package
            alias pacc="pacman -Sc"    # '[c]lean cache'    - delete all not currently installed package files
            alias pacm="makepkg -fci"  # '[m]ake'           - make package from PKGBUILD file in current directory
            alias paccurrupt='find /var/cache/pacman/pkg -name '\''*.part.*'\'''
            alias pactest='pacman -Sql testing | xargs pacman -Q 2>/dev/null'
        fi
    #}}}
    ## MULTIMEDIA #{{{
        if which get_flash_videos &>/dev/null; then
            alias gfv='get_flash_videos -r 720p --subtitles'
        fi
        if which simple-mtpfs &>/dev/null; then
          alias android-connect="simple-mtpfs /media/android"
          alias android-disconnect="fusermount -u /media/android"
        fi
    #}}}
    ## LS #{{{
        alias ls='ls -hF --color=auto'
        alias lr='ls -R'                    # recursive ls
        alias ll='ls -alh'
        alias la='ll -A'
        alias lm='la | more'
    #}}}
#}}}
## FUNCTIONS #{{{
    ## UP #{{{
    # Goes up many dirs as the number passed as argument, if none goes up by 1 by default
    function up(){
        local d=""
        limit=$1
        for ((i=1 ; i <= limit ; i++)); do
            d=$d/..
        done
        d=$(echo $d | sed 's/^\///')
        if [ -z "$d" ]; then
            d=..
        fi
        cd $d
    } #}}}
    ## COPY/MOVE DESTINY #{{{
    function goto() { [[ -d "$1" ]] && cd "$1" || cd "$(dirname "$1")"; }
    cpf() { cp "$@" && goto "$_"; }
    mvf() { mv "$@" && goto "$_"; }
    #}}}
    ## NICE MOUNT OUTPUT #{{{
    function nmount() {
        (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t
    }
    #}}}
    ## TOP 10 COMMANDS #{{{
    # copyright 2007 - 2010 Christopher Bratusek
    function top10() { history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }
    #}}}
    ## SCREENSHOT #{{{
    function shot() {
        import -frame -strip -quality 75 "$HOME/$(date +%s).png"
    }
    #}}}
    ## CONVERT TO ISO #{{{
    function to_iso () {
        if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
            echo -e "Converts raw, bin, cue, ccd, img, mdf, nrg cd/dvd image files to ISO image file.\nUsage: to_iso file1 file2..."
        fi
        for i in $*; do
            if [[ ! -f "$i" ]]; then
                echo "'$i' is not a valid file; jumping it"
            else
                echo -n "converting $i..."
                OUT=`echo $i | cut -d '.' -f 1`
                case $i in
                      *.raw ) bchunk -v $i $OUT.iso;; #raw=bin #*.cue #*.bin
                *.bin|*.cue ) bin2iso $i $OUT.iso;;
                *.ccd|*.img ) ccd2iso $i $OUT.iso;; #Clone CD images
                      *.mdf ) mdf2iso $i $OUT.iso;; #Alcohol images
                      *.nrg ) nrg2iso $i $OUT.iso;; #nero images
                          * ) echo "to_iso don't know de extension of '$i'";;
                esac
                if [[ $? != 0 ]]; then
                    echo -e "${R}ERROR!${W}"
                else
                    echo -e "${G}done!${W}"
                fi
            fi
        done
    }
    #}}}
    ## ARCHIVE EXTRACTOR #{{{
    function extract() {
        clrstart="\033[1;34m"  #color codes
        clrend="\033[0m"

        if [ "$#" -lt 1 ]
        then
            echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
            exit 1 #not enough args
        fi

        if [ ! -e "$1" ]
        then
            echo -e "${clrstart}File does not exist!${clrend}"
            exit 2 #file not found
        fi


        if [ -z "$2" ]
        then
            DESTDIR="." #set destdir to current dir
        else
            if [ ! -d "$2" ]
            then
                echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
                read response
                #echo -e "\n"
                if [ "$response" = y -o "$response" = Y ]
                then
                    mkdir -p "$2"
                    if [ $? -eq 0 ]
                    then
                        DESTDIR="$2"
                    else exit 6 #Write perms error
                    fi
                else
                    echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
                fi
            else
                DESTDIR="$2"
            fi
        fi

        if [ ! -z "$3" ]
        then
            if [ "$3" != "v" ]
            then
                echo -e "${clrstart}Wrong argument $3 !${clrend}"
                exit 4 #wrong arg 3
            fi
        fi

        filename=`basename "$1"`

        #echo "${filename##*.}" debug

        case "${filename##*.}" in
            tar)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
                tar x${3}f "$1" -C "$DESTDIR"
                ;;
            gz)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
                tar x${3}fz "$1" -C "$DESTDIR"
                ;;
            tgz)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
                tar x${3}fz "$1" -C "$DESTDIR"
                ;;
            xz)
                echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
                tar x${3}f -J "$1" -C "$DESTDIR"
                ;;
            bz2)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
                tar x${3}fj "$1" -C "$DESTDIR"
                ;;
            zip)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
                unzip "$1" -d "$DESTDIR"
                ;;
            rar)
                echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
                unrar x "$1" "$DESTDIR"
                ;;
            7z)
                echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
                7za e "$1" -o"$DESTDIR"
                ;;
            *)
                echo -e "${clrstart}Unknown archieve format!"
                exit 5
                ;;
        esac
    }
    #}}}
    ## SHOW CONTENTS #{{{
    function showcontent() {
        if [ "$#" -lt 1 ]
        then
            echo "Pass a filename. You can specify v after filename for verbose output."
            exit 2 #filename not passed
        fi

        if [ ! -e "$1" ]
        then
            echo "File does not exist!"
            exit 3 #file not found
        fi


        if [ ! -z "$2" ]
        then
            if [ "$2" = "v" ]
            then
                echo  "Verbose on." #verbose output by tar
            else
                echo "Wrong argument!"
                exit 4  #wrong second argument
            fi
        fi

        filename=`basename "$1"`

        #echo "${filename##*.}" debug

        case "${filename##*.}" in
            tar)
                echo "Displaying contents of $1: (uncompressed tar)"
                tar t${2}f "$1"
                ;;
            gz)
                echo "Displaying contents of $1: (gip compressed tar)"
                tar t${2}fz "$1"
                ;;
            tgz)
                echo "Displaying contents of $1: (gip compressed tar)"
                tar t${2}fz "$1"
                ;;
            xz)
                echo "Displaying contents of $1: (gip compressed tar)"
                tar -J "$1"
                ;;
            bz2)
                echo "Displaying contents of $1: (bzip compressed tar)"
                tar t${2}fj "$1"
                ;;
            zip)
                echo "Displaying contents of $1: (zipp compressed file)"
                unzip -l "$1"
                ;;
            rar)
                echo "Displaying contents of $1: (rar compressed file)"
                unrar l${2}t "$1"
                ;;
            7z)
                echo  "Displaying contents of $1: (7zip compressed file)"
                7za l "$1"
                ;;
            *)
                echo "Unknown archieve format!"
                exit 1
                ;;
        esac
    }
    #}}}
    ## ARCHIVE COMPRESS #{{{
    function compress () {
        if [[ -n "$1" ]] ; then
            FILE=$1
            case $FILE in
                    *.tar ) shift && tar cf $FILE $* ;;
                *.tar.bz2 ) shift && tar cjf $FILE $* ;;
                 *.tar.gz ) shift && tar czf $FILE $* ;;
                    *.tgz ) shift && tar czf $FILE $* ;;
                    *.zip ) shift && zip $FILE $* ;;
                    *.rar ) shift && rar $FILE $* ;;
                esac
        else
            echo "usage: compress <foo.tar.gz> ./foo ./bar"
        fi
    }
    #}}}
    ## REMIND ME, ITS IMPORTANT! #{{{
    # usage: remindme <time> <text>
    # e.g.: remindme 10m "omg, the pizza"
    function remindme()
    {
        sleep $1 && zenity --info --text "$2" &
    }
    #}}}
    ## SIMPLE CALCULATOR #{{{
    # usage: calc <equation>
    function calc() {
        if which bc &>/dev/null; then
            echo "scale=3; $*" | bc -l
        else
            awk "BEGIN { print $* }"
        fi
    }
    #}}}
    ## FILE & STRINGS RELATED FUNCTIONS #{{{
        ## Find a file with a pattern in name #{{{
        function ff()
        { find . -type f -iname '*'$*'*' -ls ; }
        #}}}
        ## Find a file with pattern $1 in name and Execute $2 on it #{{{
        function fe()
        { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
        #}}}
        ## Move filenames to lowercase #{{{
        function lowercase() {
            for file ; do
                filename=${file##*/}
                case "$filename" in
                    */* ) dirname==${file%/*} ;;
                      * ) dirname=.;;
            esac
            nf=$(echo $filename | tr A-Z a-z)
            newname="${dirname}/${nf}"
            if [[ "$nf" != "$filename" ]]; then
                mv "$file" "$newname"
                echo "lowercase: $file --> $newname"
            else
                echo "lowercase: $file not changed."
            fi
            done
        }
        #}}}
        ## Swap 2 filenames around, if they exist #{{{
        #(from Uzi's bashrc).
        function swap() {
            local TMPFILE=tmp.$$

            [[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
            [[ ! -e $1 ]] && echo "swap: $1 does not exist" && return 1
            [[ ! -e $2 ]] && echo "swap: $2 does not exist" && return 1

            mv "$1" $TMPFILE
            mv "$2" "$1"
            mv $TMPFILE "$2"
        }
        #}}}
        ## Finds directory sizes and lists them for the current directory #{{{
        function dirsize () {
            du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
                egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
                egrep '^ *[0-9.]*M' /tmp/list
                egrep '^ *[0-9.]*G' /tmp/list
            rm -rf /tmp/list
        }
        #}}}
    #}}}
    ## SYSTEMD SUPPORT #{{{
    if [[ -f /usr/bin/systemctl ]]; then
        start() {
            sudo systemctl start $1.service
        }

        restart() {
            sudo systemctl restart $1.service
        }

        stop() {
            sudo systemctl stop $1.service
        }

        enable() {
            sudo systemctl enable $1.service
        }

        status() {
            sudo systemctl status $1.service
        }

        disable() {
            sudo systemctl disable $1.service
        }
    fi
    #}}}
#}}}
