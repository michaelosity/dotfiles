# --- Basic
set -o vi
export EDITOR="vi"
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
export BLOCKSIZE=1m

# --- Navigation
alias j='jump'
function jump { 
export MARKPATH=$HOME/.marks
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

# --- Find files
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

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

# --- Networking
ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }

# --- Git
alias gs='git status'
alias gl='git log -n 5'
alias gpl='git pull'
alias gps='git push'
alias gd='git difftool'
alias gdc='git difftool --cached'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gmd='git merge develop'
alias grm='git rebase master'

# --- Java
#export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

# --- Android
#export ANDROID_SDK="/usr/local/opt/android-sdk"
#export ANDROID_SDK_HOME=$ANDROID_SDK
#export ANDROID_NDK="/usr/local/opt/android-ndk"
#export ANDROID_NDK_HOME=$ANDROID_NDK
#export ANDROID_HOME=$ANDROID_SDK
#if [ -d $ANDROID_SDK ]; then
#    export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools"
#fi
#if [ -d $ANDROID_NDK ]; then
#    export PATH="$PATH:$ANDROID_NDK"
#fi

# --- Haskell
#if [ -d /Users/michael/Library/Haskell/bin ]; then
#    export PATH="$PATH:/Users/michael/Library/Haskell/bin"
#fi

# Run twolfson/sexy-bash-prompt: https://github.com/twolfson/sexy-bash-prompt
. ~/.bash_prompt

# remove /usr/local/bin and /usr/bin then add them back in the order we want
export PATH=`echo ":$PATH:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
export PATH=`echo ":$PATH:" | sed -e "s:\:/usr/bin\::\::g" -e "s/^://" -e "s/:$//"`
export PATH="/usr/local/bin:/usr/bin:$PATH"

# homebrew packages sometimes include bash completion scripts (like git)
BREWPREFIX=`brew --prefix`
if [ -d $BREWPREFIX/etc/bash_completion.d ]; then
  for script in $BREWPREFIX/etc/bash_completion.d/*; do
    . $script
  done
fi
