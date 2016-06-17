#!/bin/sh
set -e

# ssh keys + config in place?
grep maj.fil ~/.ssh/id_rsa.pub &> /dev/null || echo "are your ssh keys in place duder?"

# Installs oh-my-zsh
if ! [ -f ~/.zshrc ]; then
    echo "going to install zsh, hold on to your butt"
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    # TODO: how to re-run this script w/ zsh now that its installed?
    echo "zsh installed. rerun this ($0) now."
    exit 1
fi

# Pathogen (bundle management for vim)
if ! [ -d ~/.vim/autoload ]; then
    mkdir -p ~/.vim/autoload
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Update submodules in this repo
git submodule update --init

mypath=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)
test -L ~/.vimrc || ln -s "$mypath/.vimrc" ~/.
if ! [ -L ~/.zshrc ]; then
    rm -f ~/.zshrc
    ln -s "$mypath/.zshrc" ~/.
fi
test -L ~/.vim/bundle || ln -s "$mypath/.vim/bundle" ~/.vim/.
test -L ~/.ondirrc || ln -s "$mypath/.ondirrc" ~/.
test -L ~/.gitconfig || ln -s "$mypath/.gitconfig" ~/.

# link up solarized colors
mkdir -p ~/.vim/colors
test -L ~/.vim/colors/solarized.vim || ln -s "$mypath/.vim/bundle/vim-colors-solarized/colors/solarized.vim" ~/.vim/colors/.

# Homebrew
test -x "$(command -v brew)" || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Python and its package manage
# TODO: what if im installing on linux? no brew. then what?
test -x "$(command -v python)" || brew install python
pip install virtualenv
pip install virtualenvwrapper
test -x "$(command -v pyflakes)" || pip install pyflakes
# ack for greping shiet
test -x "$(command -v ack)" || brew install ack
# ondir to run directory-specific tasks
test -x "$(command -v ondir)" || brew install ondir
# ctags for vim leetness
brew install ctags

mkdir -p ~/local

pushd ~/src
# building node.js from source because fuck it
if ! [ -d ~/src/node ]; then
    git clone git@github.com:nodejs/node.git
    pushd ~/src/node
    ./configure --prefix=$HOME/local
    make
    make install
    popd # ~/src
fi
popd

# java?
echo "gonna run java so you can open oracle site and download the JRE and JDK."
java -version
echo "should set JAVA_HOME in .zshrc"

mkdir -p ~/sdks
# TODO what about android sdk?
