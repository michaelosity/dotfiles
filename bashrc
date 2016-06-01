# --- Basic
set -o vi
export EDITOR="vi"

# --- Logging
# https://spin.atomicobject.com/2016/05/28/log-bash-history/
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

# --- Misc
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

# --- Git
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

# --- OS specific

if [ "$(uname)" == "Darwin" ] || [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

  export CLICOLOR=1
  export LSCOLORS=Gxfxcxdxbxegedabagacad
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
  export BLOCKSIZE=1m

  . ~/.bash_prompt

  alias cupd='carthage update --platform iOS --configuration Release'
  alias bupd='brew update && brew upgrade && brew cleanup'
  
  export HOMEBREW_NO_ANALYTICS=1

  # find files
  ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
  ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
  ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

  # navigation
  alias j='jump'
  export MARKPATH=${HOME}/.marks

  function jump { 
    cd -P ${MARKPATH}/$1 2>/dev/null || echo "No such mark: $1"
  }
  
  function mark { 
    mkdir -p ${MARKPATH}; ln -s $(pwd) $MARKPATH/$1
  }

  function unmark { 
    rm -i ${MARKPATH}/$1 
  }

  function marks {
    ls -l ${MARKPATH} | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
  }

fi

if [ "$(uname)" == "Darwin" ]; then

  # swift
  SWIFT_LATEST=/Library/Developer/Toolchains/swift-latest.xctoolchain

  # remove /usr/local/bin and /usr/bin then add them back in the order we want
  export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH="/usr/local/bin:/usr/bin:${PATH}"
  if [ -d "${SWIFT_LATEST}" ]; then
    export PATH=${SWIFT_LATEST}/usr/bin:"${PATH}"
  fi
   
  # homebrew packages sometimes include bash completion scripts (like git)
  if [ -d "/usr/local/Cellar" ]; then
    HOMEBREW_PREFIX=`brew --prefix`
    if [ -d ${HOMEBREW_PREFIX}/etc/bash_completion.d ]; then
     for script in ${HOMEBREW_PREFIX}/etc/bash_completion.d/*; do
       . $script
     done
    fi
  fi

  xc() {
    xcrun launch-with-toolchain ${SWIFT_LATEST}
  }

  # internet interface
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
