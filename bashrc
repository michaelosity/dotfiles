####
#### INITIALIZATION
####

# Don't do anything if not running interactively
[ -z "$PS1" ] && return

###
### PLATFORM
###

platform='unknown'
uname_string=`uname`
if [[ "${uname_string}" == 'Darwin' ]]; then
  platform='mac'
elif [[ "$(expr substr $(uname -s) 1 5)" == ‘Linux’ ]]; then
  platform='linux'
fi

###
### BASIC
###

set -o vi
export EDITOR="vi"

###
### COLORS
###

export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LSDCOLORS=Gxfxcxdxbxegedabagacad

###
### COMMON ALIASES
###

alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias h='history'
alias con="tail -40 -f /var/log/system.log"
alias cd..='cd ../'
alias ..='cd ../'
alias duh='du -h -d 1 .'
alias duh2='du -h -d 2 .'
alias duh3='du -h -d 3 .'

function xzarch {
 tar cf - $1 | xz -9 --threads=0 > $1.tar.xz 
}

###
### GIT
###

alias gs='git status'
alias gl='git log -n 5'
alias gpl='git pull'
alias gps='git push'
alias gd='git difftool'
alias gr='git remote -v'
alias gu='git up'
alias gdc='git difftool --cached'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gmd='git merge develop'
alias grm='git rebase master'

function gupd {
  for repo in `ls -d */`; do
    echo "${repo}"
    echo "------------------------------"
    (cd "${repo}" && git pull)
    echo ""
   done
}

###
### SECURE
###

[[ -s ~/.secure ]] && source ~/.secure

###
### NON-WINDOWS
###

if [[ “${platform}” == “mac” || “${platform}” == “linux” ]]; then

  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
  export BLOCKSIZE=1m

  # Find files
  ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
  ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
  ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

  # Navigation
  alias j='jump'
  export MARKPATH=${HOME}/.marks

  function jump { 
    cd -P ${MARKPATH}/$1 2>/dev/null || echo "No such mark: $1"
  }
  
  function mark { 
    mkdir -p ${MARKPATH}; ln -s $(pwd) ${MARKPATH}/$1
  }

  function unmark { 
    rm -i ${MARKPATH}/$1 
  }

  function marks {
    ls -l ${MARKPATH} | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
  }

fi

###
### MAC
###

if [[ “${platform}” == “mac” ]]; then

  # Java
  export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

  # Swift
  latest_swift=/Library/Developer/Toolchains/swift-latest.xctoolchain
  xc() {
    xcrun launch-with-toolchain ${latest_swift}
  } 

  # Remove /usr/local/bin and /usr/bin then add them back in the order we want
  export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH="/usr/local/bin:/usr/bin:~/bin:${PATH}"
  if [ -d "${latest_swift}" ]; then
    export PATH=${latest_swift}/usr/bin:"${PATH}"
  fi
   
  # Homebrew
  alias bl='brew list'
  alias bupd='brew update && brew upgrade && brew cleanup'
  export HOMEBREW_NO_ANALYTICS=1
  if [ -d "/usr/local/Cellar" ]; then
    homebrew_prefix=`brew --prefix`
    if [ -d ${homebrew_prefix}/etc/bash_completion.d ]; then
     for script in ${homebrew_prefix}/etc/bash_completion.d/*; do
       . $script
     done
    fi
  fi

  # Carthage
  alias cout='carthage outdated'
  alias cupd='carthage update --platform iOS --configuration Release --no-use-binaries'

  # Internet Interface
  ii() {
    echo -e "\nHOST\n${HOSTNAME}"
    echo -e "\nADDITIONAL INFORMATION" ; uname -a
    echo -e "\nMACHINE STATS" ; uptime
    echo -e "\nCURRENT NETWORK LOCATION" ; scselect
    echo -e "\nIP ADDRESS (PRIVATE)" ; ipconfig getifaddr en0 
    echo -e "\nIP ADDRESS (PUBLIC)" ; curl ipecho.net/plain ; echo
    echo
  }

fi

###
### BASH HISTORY
###

export HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite itj
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

###
### PROMPT
###

# http://web.archive.org/web/20131009193526/http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux

reset_style="\[\e[0m\]"
grey_style="\[\e[48;5;8m\e[38;5;15m\]"    # grey (8m) background, white (15m) foreground
blue_style="\[\e[48;5;24m\e[38;5;15m\]"   # blue (24m) background, white (15m) foreground
green_style="\[\e[48;5;28m\e[38;5;15m\]"  # green (28m) background, white (15m) foreground
title_style="\[\e]0;\w\007\]"             # sets window title to current working directory

__prompt_git() {

    local branch_name=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branch_name="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                      git rev-parse --short HEAD 2> /dev/null || \
                      printf "(unknown)")"

        printf " $branch_name "
    else
        return
    fi
}

export PS1="$title_style\n$grey_style \u@\h $blue_style \w $green_style\$(__prompt_git)$reset_style\n\$ "
