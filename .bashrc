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
## PS1 CONFIG {{{
  [[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)
  if $_isxrunning; then

    [[ -f $HOME/.dircolors_256 ]] && eval $(dircolors -b $HOME/.dircolors_256)

    export TERM='xterm-256color'

    B='\[\e[1;38;5;33m\]'
    LB='\[\e[1;38;5;81m\]'
    GY='\[\e[1;38;5;242m\]'
    G='\[\e[1;38;5;82m\]'
    P='\[\e[1;38;5;161m\]'
    PP='\[\e[1;38;5;93m\]'
    R='\[\e[1;38;5;196m\]'
    Y='\[\e[1;38;5;214m\]'
    W='\[\e[0m\]'

    if ! $_isroot; then
      export PS1="$GY[$Y\u$GY@$P\h$W:$B\W$GY]$W\$ "
    else
      export PS1="$GY[$R\u$GY@$P\h$W:$B\W$GY]$W# "
    fi
  else
    export TERM='xterm-color'
  fi
#}}}
## BASH OPTIONS {{{
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
## EXPORTS {{{
  export PATH=/usr/local/bin:$PATH
  #Ruby support
  if which ruby &>/dev/null; then
    GEM_DIR=$(ruby -rubygems -e 'puts Gem.user_dir')/bin
    if [[ -d "$GEM_DIR" ]]; then
      export PATH=$GEM_DIR:$PATH
    fi
  fi
  ## EDITOR #{{{
    if which vim &>/dev/null; then
      export EDITOR="vim"
    elif which emacs &>/dev/null; then
      export EDITOR="emacs -nw"
    else
      export EDITOR="nano"
    fi
  #}}}
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
## ALIAS {{{
  alias freemem='sudo /sbin/sysctl -w vm.drop_caches=3'
  alias enter_matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'
  # MODIFIED COMMANDS {{{
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
  # PRIVILEGED ACCESS {{{
    if ! $_isroot; then
      alias sudo='sudo '
      alias scat='sudo cat'
      alias svim='sudo vim'
      alias root='sudo su'
      alias reboot='sudo reboot'
      alias halt='sudo halt'
    fi
  #}}}
  # PACMAN ALIASES {{{
    # we're on ARCH
    if $_isarch; then
      # we're not root
      if ! $_isroot; then
        alias pacman='sudo pacman'
      fi
      alias pacupg='pacman -Syu'            # Synchronize with repositories and then upgrade packages that are out of date on the local system.
      alias pacupd='pacman -Sy'             # Refresh of all package lists after updating /etc/pacman.d/mirrorlist
      alias pacin='pacman -S'               # Install specific package(s) from the repositories
      alias pacinu='pacman -U'              # Install specific local package(s)
      alias pacre='pacman -R'               # Remove the specified package(s), retaining its configuration(s) and required dependencies
      alias pacun='pacman -Rcsn'            # Remove the specified package(s), its configuration(s) and unneeded dependencies
      alias pacinfo='pacman -Si'            # Display information about a given package in the repositories
      alias pacse='pacman -Ss'              # Search for package(s) in the repositories

      alias pacupa='pacman -Sy && sudo abs' # Update and refresh the local package and ABS databases against repositories
      alias pacind='pacman -S --asdeps'     # Install given package(s) as dependencies of another package
      alias pacclean="pacman -Sc"           # Delete all not currently installed package files
      alias pacmake="makepkg -fcsi"         # Make package from PKGBUILD file in current directory
    fi
  #}}}
  # MULTIMEDIA {{{
    if which get_flash_videos &>/dev/null; then
      alias gfv='get_flash_videos -r 720p --subtitles'
    fi
    if which simple-mtpfs &>/dev/null; then
      alias android-connect="simple-mtpfs /media/android"
      alias android-disconnect="fusermount -u /media/android"
    fi
  #}}}
  # LS {{{
    alias ls='ls -hF --color=auto'
    alias lr='ls -R'                    # recursive ls
    alias ll='ls -alh'
    alias la='ll -A'
    alias lm='la | more'
  #}}}
#}}}
## FUNCTIONS {{{
  # SUPERGIT {{{
    sit(){
      # By helmuthdu
      usage(){
        echo "Usage: $0 [options]"
        echo "au| autoconfig                       :Autoconfigure git options"
        echo "a | add [--all] || \"<files>\"         :Add git files"
        echo "c | commit [--undo] || \"<text>\"      :Add git files"
        echo "b | branch [feature, hotfix, <any>]  :Add/Change Branch"
        echo "d | delete [branch] <name>           :Delete Branch"
        echo "l | log                              :Display Log"
        echo "m | merge [feature, hotfix, <any>]   :Merge branches"
        echo "p | push <branch>                    :Push files"
        echo "P | pull <branch>                    :Pull files"
        echo "r | release                          :Merge devel branch on master"
        echo ""
      }
      if [[ $# -eq 0 ]]; then
        usage
      else
        check_onfire=`git branch | grep onfire`
        check_hotfix=`git branch | grep hotfix`
      fi
      case $1 in
        au | autoconfig)
          local NAME=`git config --global user.name`
          local EMAIL=`git config --global user.email`
          local USER=`git config --global github.user`
          local EDITOR=`git config --global core.editor`

          [[ -z $NAME ]] && read -p "Nome: " NAME
          [[ -z $EMAIL ]] && read -p "Email: " EMAIL
          [[ -z $USER ]] && read -p "Username: " USER
          [[ -z $EDITOR ]] && read -p "Editor: " EDITOR

          git config --global user.name $NAME
          git config --global user.email $EMAIL
          git config --global github.user $USER
          git config --global color.ui true
          git config --global color.status auto
          git config --global color.branch auto
          git config --global color.diff auto
          git config --global diff.color true
          git config --global push.default matching
          git config --global core.editor $EDITOR
          git config --global alias.undo-commit 'reset --soft HEAD^'
          if which meld &>/dev/null; then
            git config --global diff.guitool meld
            git config --global merge.tool meld
          elif which kdiff3 &>/dev/null; then
            git config --global diff.guitool kdiff3
            git config --global merge.tool kdiff3
          fi
          git config --global --list
          ;;
        a | add)
          if [[ $2 == --all ]]; then
            git add -A
          else
            git add $2
          fi
          ;;
        c | commit )
          if [[ $2 == --undo ]]; then
            git reset --soft HEAD^
          else
            git commit -am "$2"
          fi
          ;;
        b | branch )
          case $2 in
            feature)
              [[ -z $check_onfire ]] && git checkout -b feature --track origin/onfire
              ;;
            hotfix)
              git ckeckout -b hotfix master
              ;;
            *)
              check_branch=`git branch | grep $2`
              [[ -z $check_branch ]] && git branch -f $2 origin/$2
              git checkout -b $2
              ;;
          esac
          ;;
        d | delete)
          case $2 in
            branch)
              git branch -d $3
              git push origin --delete $3
              ;;
            *)
              echo "Invalid argument"
              ;;
          esac
          ;;
        l | log )
          git log
          ;;
        m | merge )
          case $2 in
            --fix)
              git mergetool
              ;;
            feature)
              if [[ -z $check_onfire ]]; then
                git checkout onfire
                git difftool -g -d onfire..feature
                git merge --no-ff feature
                git branch -d feature
                git commit -am "${3}"
              else
                echo "No onfire branch founded."
              fi
              ;;
            hotfix)
              if [[ -z $check_hotfix ]]; then
                # get upstream branch
                git checkout -b onfire origin
                git merge --no-ff hotfix
                git commit -am "hotfix: v${3}"
                # get master branch
                git checkout -b master origin
                git merge hotfix
                git commit -am "Hotfix: v${3}"
                git branch -d hotfix
                git tag -a $3 -m "Release: v${3}"
                git push --tags
              else
                echo "No hotfix branch founded."
              fi
              ;;
            *)
              check_branch=`git branch | grep $2`
              if [[ -z $check_branch ]]; then
                git checkout -b master origin
                git difftool -g -d master..$2
                git merge --no-ff $2
                git branch -d $2
                git commit -am "${3}"
              else
                echo "No onfire branch founded."
              fi
              ;;
          esac
          ;;
        p | push )
          git push origin $2
          ;;
        P | pull )
          git pull origin $2
          ;;
        r | release )
          git checkout origin/master
          git merge --no-ff origin/onfire
          git branch -d onfire
          git tag -a $2 -m "Release: v${2}"
          git push --tags
          ;;
      esac
    }
  #}}}
  # TOP 10 COMMANDS {{{
    # copyright 2007 - 2010 Christopher Bratusek
    top10() { history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }
  #}}}
  # UP {{{
    # Goes up many dirs as the number passed as argument, if none goes up by 1 by default
    up() {
      local d=""
      limit=$1
      for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
      done
      d=$(echo $d | sed 's/^\///')
      if [[ -z "$d" ]]; then
        d=..
      fi
      cd $d
    }
  #}}}
  # ARCHIVE EXTRACTOR {{{
    extract() {
      clrstart="\033[1;34m"  #color codes
      clrend="\033[0m"

      if [[ "$#" -lt 1 ]]; then
        echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
        exit 1 #not enough args
      fi

      if [[ ! -e "$1" ]]; then
        echo -e "${clrstart}File does not exist!${clrend}"
        exit 2 #file not found
      fi

      if [[ -z "$2" ]]; then
        DESTDIR="." #set destdir to current dir
      elif [[ ! -d "$2" ]]; then
        echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
        read response
        #echo -e "\n"
        if [[ $response == y || $response == Y ]]; then
          mkdir -p "$2"
          if [ $? -eq 0 ]; then
            DESTDIR="$2"
          else
            exit 6 #Write perms error
          fi
        else
          echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
        fi
      else
        DESTDIR="$2"
      fi

      if [[ ! -z "$3" ]]; then
        if [[ "$3" != "v" ]]; then
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
  # ARCHIVE COMPRESS {{{
    compress() {
      if [[ -n "$1" ]]; then
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
  # CONVERT TO ISO {{{
    to_iso () {
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
  # REMIND ME, ITS IMPORTANT! {{{
    # usage: remindme <time> <text>
    # e.g.: remindme 10m "omg, the pizza"
    remindme() { sleep $1 && zenity --info --text "$2" & }
  #}}}
  # SIMPLE CALCULATOR #{{{
    # usage: calc <equation>
    calc() {
      if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
      else
        awk "BEGIN { print $* }"
      fi
    }
  #}}}
  # FILE & STRINGS RELATED FUNCTIONS {{{
    ## Find a file with a pattern in name {{{
      ff() { find . -type f -iname '*'$*'*' -ls ; }
    #}}}
    ## Find a file with pattern $1 in name and Execute $2 on it {{{
      fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
    #}}}
    ## Move filenames to lowercase {{{
      lowercase() {
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
    ## Swap 2 filenames around, if they exist {{{
      #(from Uzi's bashrc).
      swap() {
        local TMPFILE=tmp.$$

        [[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
        [[ ! -e $1 ]] && echo "swap: $1 does not exist" && return 1
        [[ ! -e $2 ]] && echo "swap: $2 does not exist" && return 1

        mv "$1" $TMPFILE
        mv "$2" "$1"
        mv $TMPFILE "$2"
      }
    #}}}
    ## Finds directory sizes and lists them for the current directory {{{
      dirsize () {
        du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
        egrep '^ *[0-9.]*M' /tmp/list
        egrep '^ *[0-9.]*G' /tmp/list
        rm -rf /tmp/list
      }
    #}}}
  #}}}
  # SYSTEMD SUPPORT {{{
    if which systemctl &>/dev/null; then
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
