# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages npm env)

source $ZSH/oh-my-zsh.sh

# languages and runtime stuff
# python
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/src
# java
# TODO: hard coding versions here sux
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
export PATH=/usr/local/opt/ruby/bin:$PATH:$HOME/bin:$HOME/.local/bin:$HOME/Library/Python/3.6/bin:$JAVA_HOME/bin:$HOME/src/node/out/bin:/usr/local/Cellar/python3/3.7.0/bin

export AWS_REGION=us-west-2 # west coast best coast
export AWS_PROFILE=default

# zsh only. ctrl-z sends to bg as well as brings back to fg
# useful in vim to quickly switch between full shell and vim.
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# ---
# zsh change-directory hooks
# ---
# Adds node_modules/.bin to the PATH
npm_chpwd_hook() {
    if [ -n "${PRENPMPATH+x}" ]; then
        PATH=$PRENPMPATH
        unset PRENPMPATH
    fi
    if [ -f package.json ]; then
        PRENPMPATH=$PATH
        PATH=$(npm bin):$PATH
    fi
}
chpwd_functions=( npm_chpwd_hook $chpwd_functions )

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
ssh-add -A &> /dev/null
# trigger detection of npm binaries on first load, in case we load the terminal
# in a node.js project directory
npm_chpwd_hook

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/.local/google-cloud-sdk/path.zsh.inc' ]; then source '~/.local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/maj/.local/google-cloud-sdk/completion.zsh.inc' ]; then source '~/.local/google-cloud-sdk/completion.zsh.inc'; fi

SPACESHIP_TIME_SHOW=true

source /Users/maj/Library/Preferences/org.dystroy.broot/launcher/bash/br
