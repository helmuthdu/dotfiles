# Archlinux Ultimate Install - .bashrc
# by helmuthdu
# OVERALL CONDITIONALS {{{
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true
# }}}
# PS1 CONFIG {{{
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

    get_prompt_symbol() {
      [[ $UID == 0 ]] && echo "#" || echo "\$"
    }

    if [[ $PS1 && -f /usr/share/git/git-prompt.sh ]]; then
      source /usr/share/git/completion/git-completion.bash
      source /usr/share/git/git-prompt.sh

      export GIT_PS1_SHOWDIRTYSTATE=1
      export GIT_PS1_SHOWSTASHSTATE=1
      export GIT_PS1_SHOWUNTRACKEDFILES=0

      export PS1="$GY[$Y\u$GY@$P\h$GY:$B\W\$(__git_ps1 \"$GY|$LB%s\")$GY]$W\$(get_prompt_symbol) "
    else
      export PS1="$GY[$Y\u$GY@$P\h$GY:$B\W$GY]$W\$(get_prompt_symbol) "
    fi
  else
    export TERM='xterm-color'
  fi
#}}}
# BASH OPTIONS {{{
  shopt -s cdspell                 # Correct cd typos
  shopt -s checkwinsize            # Update windows size on command
  shopt -s histappend              # Append History instead of overwriting file
  shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
  shopt -s extglob                 # Extended pattern
  shopt -s no_empty_cmd_completion # No empty completion
  # COMPLETION {{{
    complete -cf sudo
    if [[ -f /etc/bash_completion ]]; then
      . /etc/bash_completion
    fi
  #}}}
#}}}
# CONFIG {{{
  export PATH=/usr/local/bin:$PATH
  if [[ -d "$HOME/bin" ]] ; then
      PATH="$HOME/bin:$PATH"
  fi
  # RUBY {{{
    if which ruby &>/dev/null; then
      GEM_DIR=$(ruby -rubygems -e 'puts Gem.user_dir')/bin
      if [[ -d "$GEM_DIR" ]]; then
        export PATH=$GEM_DIR:$PATH
      fi
    fi
  #}}}
  # NVM {{{
    if [[ -f "/usr/share/nvm/nvm.sh" ]]; then
      source /usr/share/nvm/init-nvm.sh
    fi
  #}}}
  # CHRUBY {{{
    if [[ -f "/usr/share/chruby/chruby.sh" ]]; then
      source /usr/share/chruby/chruby.sh
    fi
  #}}}
  # VTE {{{
    if [[ -f "/etc/profile.d/vte.sh" ]]; then
      . /etc/profile.d/vte.sh
    fi
  #}}}
  # ANDROID SDK {{{
    if [[ -d "/opt/android-sdk" ]]; then
      export ANDROID_HOME=/opt/android-sdk
    fi
  #}}}
  # CHROME {{{
    if which google-chrome-stable &>/dev/null; then
      export CHROME_BIN=/usr/bin/google-chrome-stable
    fi
  #}}}
  # EDITOR {{{
    if which vim &>/dev/null; then
      export EDITOR="vim"
    elif which emacs &>/dev/null; then
      export EDITOR="emacs -nw"
    else
      export EDITOR="nano"
    fi
  #}}}
  # BASH HISTORY {{{
    # make multiple shells share the same history file
    export HISTSIZE=1000            # bash history will save N commands
    export HISTFILESIZE=${HISTSIZE} # bash will remember N commands
    export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
    export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
  #}}}
  # COLORED MANUAL PAGES {{{
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
# ALIAS {{{
  alias freemem='sudo /sbin/sysctl -w vm.drop_caches=3'
  alias enter_matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'
  # GIT_OR_HUB {{{
    if which hub &>/dev/null; then
      alias git=hub
    fi
  #}}}
  # AUTOCOLOR {{{
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  #}}}
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
  #}}}
  # LS {{{
    alias ls='ls -hF --color=auto'
    alias lr='ls -R'                    # recursive ls
    alias ll='ls -alh'
    alias la='ll -A'
    alias lm='la | less'
  #}}}
#}}}
# FUNCTIONS {{{
  # BETTER GIT COMMANDS {{{
    bit() {
      # By helmuthdu
      usage(){
        echo "Usage: $0 [options]"
        echo "  --init                                              # Autoconfigure git options"
        echo "  a, [add] <files> [--all]                            # Add git files"
        echo "  c, [commit] <text> [--undo]                         # Add git files"
        echo "  C, [cherry-pick] <number> <url> [branch]            # Cherry-pick commit"
        echo "  b, [branch] feature|hotfix|<name>                   # Add/Change Branch"
        echo "  d, [delete] <branch>                                # Delete Branch"
        echo "  l, [log]                                            # Display Log"
        echo "  m, [merge] feature|hotfix|<name> <commit>|<version> # Merge branches"
        echo "  p, [push] <branch>                                  # Push files"
        echo "  P, [pull] <branch> [--foce]                         # Pull files"
        echo "  r, [release]                                        # Merge unstable branch on master"
        return 1
      }
      case $1 in
        --init)
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
          git config --global core.filemode true
          git config --global push.default matching
          git config --global core.editor $EDITOR
          git config --global format.signoff true
          git config --global alias.reset 'reset --soft HEAD^'
          git config --global alias.graph 'log --graph --oneline --decorate'
          git config --global alias.compare 'difftool --dir-diff HEAD^ HEAD'
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
        b | branch )
          check_branch=`git branch | grep $2`
          case $2 in
            feature)
              check_unstable_branch=`git branch | grep unstable`
              if [[ -z $check_unstable_branch ]]; then
                echo "creating unstable branch..."
                git branch unstable
                git push origin unstable
              fi
              git checkout -b feature --track origin/unstable
              ;;
            hotfix)
              git checkout -b hotfix master
              ;;
            master)
              git checkout master
              ;;
            *)
              check_branch=`git branch | grep $2`
              if [[ -z $check_unstable_branch ]]; then
                echo "creating $2 branch..."
                git branch $2
                git push origin $2
              fi
              git checkout $2
              ;;
          esac
          ;;
        c | commit )
          if [[ $2 == --undo ]]; then
            git reset --soft HEAD^
          else
            git commit -am "$2"
          fi
          ;;
        C | cherry-pick )
          git checkout -b patch master
          git pull $2 $3
          git checkout master
          git cherry-pick $1
          git log
          git branch -D patch
          ;;
        d | delete)
          check_branch=`git branch | grep $2`
          if [[ -z $check_branch ]]; then
            echo "No branch founded."
          else
            git branch -D $2
            git push origin --delete $2
          fi
          ;;
        l | log )
          git log --graph --oneline --decorate
          ;;
        m | merge )
          check_branch=`git branch | grep $2`
          case $2 in
            --fix)
              git mergetool
              ;;
            feature)
              if [[ -n $check_branch ]]; then
                git checkout unstable
                git difftool -g -d unstable..feature
                git merge --no-ff feature
                git branch -d feature
                git commit -am "${3}"
              else
                echo "No unstable branch founded."
              fi
              ;;
            hotfix)
              if [[ -n $check_branch ]]; then
                # get upstream branch
                git checkout -b unstable origin
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
              if [[ -n $check_branch ]]; then
                git checkout -b master origin
                git difftool -g -d master..$2
                git merge --no-ff $2
                git branch -d $2
                git commit -am "${3}"
              else
                echo "No unstable branch founded."
              fi
              ;;
          esac
          ;;
        p | push )
          git push origin $2
          ;;
        P | pull )
          if [[ $2 == --force ]]; then
            git fetch --all
            git reset --hard origin/master
          else
            git pull origin $2
          fi
          ;;
        r | release )
          git checkout origin/master
          git merge --no-ff origin/unstable
          git branch -d unstable
          git tag -a $2 -m "Release: v${2}"
          git push --tags
          ;;
        *)
          usage
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
    ## FIND A FILE WITH A PATTERN IN NAME {{{
      ff() { find . -type f -iname '*'$*'*' -ls ; }
    #}}}
    ## FIND A FILE WITH PATTERN $1 IN NAME AND EXECUTE $2 ON IT {{{
      fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
    #}}}
    ## MOVE FILENAMES TO LOWERCASE {{{
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
    ## SWAP 2 FILENAMES AROUND, IF THEY EXIST {{{
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
    ## FINDS DIRECTORY SIZES AND LISTS THEM FOR THE CURRENT DIRECTORY {{{
      dirsize () {
        du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
        egrep '^ *[0-9.]*M' /tmp/list
        egrep '^ *[0-9.]*G' /tmp/list
        rm -rf /tmp/list
      }
    #}}}
    ## FIND AND REMOVED EMPTY DIRECTORIES {{{
      fared() {
        read -p "Delete all empty folders recursively [y/N]: " OPT
        [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
      }
    #}}}
    ## FIND AND REMOVED ALL DOTFILES {{{
      farad () {
        read -p "Delete all dotfiles recursively [y/N]: " OPT
        [[ $OPT == y ]] && find . -name '.*' -type f -exec rm -rf {} \;
      }
    #}}}

  #}}}
  # ENTER AND LIST DIRECTORY{{{
    function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }
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
