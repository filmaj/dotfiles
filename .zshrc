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
#
# languages and runtime stuff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/src
export JAVA_HOME=`/usr/libexec/java_home -v 11`
export PYTHON_HOME=/usr/local/Cellar/python3/3.7.7
export PYTHON_LIBRARIES=$HOME/Library/Python/3.7
export PATH=/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH:$HOME/bin:$HOME/.local/bin:$PYTHON_LIBRARIES/bin:$JAVA_HOME/bin:$HOME/src/node/out/bin:$PYTHON_HOME/bin:/Users/filmaj/Library/Python/2.7/bin

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# NVM for managing node
export NVM_DIR="/usr/local/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go shit
export GOPATH=$HOME/go
export GOROOT=$(go env | grep GOROOT | awk -F "=" '{print $2}')
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages npm ssh-agent zsh-node-path dotenv)
zstyle :omz:plugins:ssh-agent agent-forwarding on

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

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
ssh-add -A &> /dev/null

SPACESHIP_TIME_SHOW=true
export CPATH=`xcrun --show-sdk-path`/usr/include

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/filmaj/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/filmaj/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/filmaj/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/filmaj/google-cloud-sdk/completion.zsh.inc'; fi

# Enable auto-switching between Ruby versions
# source /usr/local/opt/chruby/share/chruby/chruby.sh
# source /usr/local/opt/chruby/share/chruby/auto.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Load pyenv into the shell by adding
# the following to ~/.zshrc:

eval "$(pyenv init -)"

eval "$(rbenv init -)"

source $ZSH/oh-my-zsh.sh
