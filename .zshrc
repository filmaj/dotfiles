# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="spaceship"
# Other theme related options
SPACESHIP_TIME_SHOW=true
export BAT_THEME="Nord"
export LS_COLORS="di=34;40:ln=36;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

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
#
# languages and runtime stuff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/src
export JAVA_HOME=`/usr/libexec/java_home -v 22`
export PYTHON_HOME=/usr/local/Cellar/python3/3.7.7
export PYTHON_LIBRARIES=$HOME/Library/Python/3.7
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$PYTHON_LIBRARIES/bin:$JAVA_HOME/bin:$HOME/src/node/out/bin:$PYTHON_HOME/bin:/Users/filmaj/Library/Python/2.7/bin

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/src/dotfiles/custom

# go shit
export GOPATH=$HOME/go
export GOROOT=$(go env | grep GOROOT | awk -F "=" '{print $2}' | tr -d '"' | tr -d "'")
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages npm ssh-agent dotenv nvm)
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle ':omz:plugins:nvm' autoload yes

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

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
ssh-add -A &> /dev/null

export CPATH=`xcrun --show-sdk-path`/usr/include

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/filmaj/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/filmaj/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/filmaj/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/filmaj/google-cloud-sdk/completion.zsh.inc'; fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
which pyenv 2>&0 > /dev/null && eval "$(pyenv init --path) " || true

export PATH="$HOME/.rbenv/bin:$PATH"
which rbenv 2>&0 > /dev/null && eval "$(rbenv init -)" || true

#export PATH="$HOME/.jenv/bin:$PATH"
#which jenv 2>&0 > /dev/null && eval "$(jenv init -)" || true

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# work shit
/usr/bin/ssh-add --apple-load-keychain >/dev/null 2>&1

alias l="gls --color -lah"
alias la="gls --color -lAh"
alias ll="gls --color -lh"
alias ls="gls --color -G"
alias lsa="gls --color -lah"
##############################################
# Adding Source for use with Webapp and Artifactory
##############################################
source /Users/fmaj/.slack_webapp_artifactory
