#!/bin/bash
set -xe

# ssh keys + config in place?
(test -e "~/.ssh/id_rsa.pub" && grep maj.fil ~/.ssh/id_rsa.pub &> /dev/null) || (echo "are your ssh keys in place duder?" && exit 1)

mypath=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

distro=$(uname -s)
# Homebrew / apt basics.
if [ "$distro" = "Darwin" ]; then
    test -x "$(command -v brew)" || (echo "installing homebrew...." && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")
    brew update
elif [ "$distro" = "Linux" ]; then
    sudo apt-get update
fi

# mac and linux friendly package installation
install() {
    local pkg=$1
    if [ "$distro" = "Linux" ]; then
        case $pkg in
            ack)
                pkg="ack-grep" ;;
            ctags)
                pkg="exuberant-ctags"
        esac
        sudo apt-get install -y $pkg
    elif [ "$distro" = "Darwin" ]; then
        brew install $pkg
    fi
}

test -x "$(command -v git)" || install git

# Installs oh-my-zsh
if [[ $SHELL != *"zsh"* ]]; then
    echo "going to install zsh, hold on to your butt"
    install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # TODO: how to re-run this script w/ zsh now that its installed?
    echo "zsh installed. rerun this ($0) now."
    exit 1
fi

# Update submodules in this repo
git submodule update --init

# Pathogen (bundle management for vim)
if ! [ -d ~/.vim/autoload ]; then
    mkdir -p ~/.vim/autoload
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

test -L ~/.vimrc || ln -s "$mypath/.vimrc" ~/.
if ! [ -L ~/.zshrc ]; then
    rm -f ~/.zshrc
    ln -s "$mypath/.zshrc" ~/.
fi
test -L ~/.vim/bundle || ln -s "$mypath/.vim/bundle" ~/.vim/.
test -L ~/.ondirrc || ln -s "$mypath/.ondirrc" ~/.
test -L ~/.gitconfig || ln -s "$mypath/.gitconfig" ~/.

# ctags for vim leetness
install ctags

# ack for greping shiet
test -x "$(command -v ack)" || install ack

# Python and its package manager
# TODO: maybe put this behind a "do u want python? y/n"
test -x "$(command -v python)" || install python
# brew installs pip w/ python, apt-get does not.
test -x "$(command -v pip)" || ([ "$distro" = "Linux" ] && sudo apt-get install -y python-pip)
pip install --user virtualenv
pip install --user virtualenvwrapper
test -x "$(command -v pyflakes)" || pip install --user pyflakes

# TODO: how to install these on linux?
if [ "$distro" = "Darwin" ]; then
    brew install ondir
    brew install vim
    # you can install virtualbox and vagrant on mac with brew. amazeballs.
    # i stole the below from http://sourabhbajaj.com/mac-setup/ which is an amazing resource btw
    brew cask install virtualbox
    brew cask install vagrant
    brew cask install vagrant-manager
    echo "gonna run java so you can open oracle site and download the JRE and JDK. manually. like the pitiful human that you are."
    java -version
    echo "go set JAVA_HOME in .zshrc"
    echo "import the color palette into iterm"
fi

# this is on the $PATH in .zshrc, is where i put built shit
mkdir -p ~/.local

pushd ~/src
# building node.js from source because fuck it
if ! [ -d ~/src/node ]; then
    git clone git@github.com:nodejs/node.git
    pushd ~/src/node
    ./configure --prefix=$HOME/.local
    make
    make install
    popd # ~/src
fi
popd # pwd

mkdir -p ~/sdks
# TODO what about android sdk?
