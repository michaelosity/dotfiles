# --- Basic
set -o vi
export EDITOR="vi"

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

# --- Git
alias gs='git status'
alias gl='git log -n 5'
alias gpl='git pull'
alias gps='git push'
alias gd='git difftool'
alias gr='git remote -v'
alias gdc='git difftool --cached'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gmd='git merge develop'
alias grm='git rebase master'

# --- OS specific

if [ "$(uname)" == "Darwin" ] || [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

  export CLICOLOR=1
  export LSCOLORS=Gxfxcxdxbxegedabagacad
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'
  export BLOCKSIZE=1m

  . ~/.bash_prompt

  # find files
  ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
  ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
  ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

  # navigation
  alias j='jump'
  export MARKPATH=$HOME/.marks

  function jump { 
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
  }
  
  function mark { 
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
  }

  function unmark { 
    rm -i $MARKPATH/$1 
  }

  function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
  }

fi

if [ "$(uname)" == "Darwin" ]; then

  # remove /usr/local/bin and /usr/bin then add them back in the order we want
  export PATH=`echo ":$PATH:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH=`echo ":$PATH:" | sed -e "s:\:/usr/bin\::\::g" -e "s/^://" -e "s/:$//"`
  export PATH="/usr/local/bin:/usr/bin:$PATH"

  # homebrew packages sometimes include bash completion scripts (like git)
  if [ -d "/usr/local/Cellar" ]; then
    BREWPREFIX=`brew --prefix`
    if [ -d $BREWPREFIX/etc/bash_completion.d ]; then
     for script in $BREWPREFIX/etc/bash_completion.d/*; do
       . $script
     done
    fi
  fi

  # internet interface
  ii() {
    echo -e "\nHOST\n$HOSTNAME"
    echo -e "\nADDITIONAL INFORMATION" ; uname -a
    echo -e "\nMACHINE STATS" ; uptime
    echo -e "\nCURRENT NETWORK LOCATION" ; scselect
    echo -e "\nIP ADDRESS (PRIVATE)" ; ipconfig getifaddr en0 
    echo -e "\nIP ADDRESS (PUBLIC)" ; curl ipecho.net/plain ; echo
    echo
  }

fi
