# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/michael/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages xcode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export EDITOR="vim"

# Stop it with the confirmations on rm
setopt rmstarsilent

# Common Aliases

alias duh='du -h -d 1 .'
alias duh2='du -h -d 2 .'
alias duh3='du -h -d 3 .'

### GIT

alias l='ls'
alias ll='ls -l'
alias la='ls -la'
alias h='history'
alias con="tail -40 -f /var/log/system.log"
alias cd..='cd ../'
alias ..='cd ../'
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

### Navigation

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

### Java

export JAVA_HOME=`/usr/libexec/java_home -v 11`

#### Swift

alias flr='bundle exec fastlane release'
alias fls='bundle exec fastlane stage'
alias flt='bundle exec fastlane test'
alias flv='bundle exec fastlane version'
alias ac='swiftlint autocorrect'
alias sg='swiftgen'

latest_swift=/Library/Developer/Toolchains/swift-latest.xctoolchain
xc() {
	xcrun launch-with-toolchain ${latest_swift}
} 

### Homebrew

alias bl='brew list'
alias bupd='brew update && brew upgrade && brew cleanup'
export HOMEBREW_NO_ANALYTICS=1
if [ -d "/usr/local/Cellar" ]; then
homebrew_prefix=`brew --prefix`
if [ -d ${homebrew_prefix}/etc/zsh_completion.d ]; then
 for script in ${homebrew_prefix}/etc/zsh_completion.d/*; do
   . $script
 done
fi
fi

### Carthage
alias cout='carthage outdated'
alias cupd='carthage update --platform iOS --configuration Release --no-use-binaries --cache-builds'

### External

[[ -s ~/.incrementalsoftware.zsh ]] && source ~/.incrementalsoftware.zsh
[[ -s ~/.velky.zsh ]] && source ~/.velky.zsh
[[ -s ~/.fastlane.zsh ]] && source ~/.fastlane.zsh

###  Path

# Remove /usr/local/bin and /usr/bin then add them back in the order we want
export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/local/bin\::\::g" -e "s/^://" -e "s/:$//"`
export PATH=`echo ":${PATH}:" | sed -e "s:\:/usr/bin\::\::g" -e "s/^://" -e "s/:$//"`
export PATH="/usr/local/bin:/usr/bin:~/bin:${PATH}"
if [ -d "${latest_swift}" ]; then
	export PATH=${latest_swift}/usr/bin:"${PATH}"
fi

### Ruby 

eval "$(rbenv init -)"

