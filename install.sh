#!/bin/sh

# TODO: did you put your ssh keys + config in place?

# Installs oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# TODO: how to re-run this script w/ zsh now that its installed?
# Pathogen (bundle management for vim)
mkdir -p ~/.vim/autoload
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git submodule update --init
# TODO: need full paths to files here
ln -s .vimrc ~/.
ln -s bundle ~/.vim/.
mkdir -p ~/.vim/colors
# TODO: link up solarized colors
ln -s .ondirrc ~/.
ln -s .gitconfig ~/.
# Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Python and its package manage
brew install python
pip install virtualenv
pip install virtualenvwrapper
pip install pyflakes
brew install ack
brew install ondir
# TODO: install android sdks
mkdir -p ~/sdks
# java?
echo "gonna run java so you can open oracle site and download the JRE and JDK."
java -version
echo "should set JAVA_HOME in .zshrc"
mkdir -p ~/local
pushd ~/src
# node.js
git clone git@github.com:joyent/node.git
pushd ~/src/node
./configure --prefix=$HOME/local
make
make install
popd # ~/src
popd


echo "you probably need to create an AOSP disk"
echo "update your android sdks."
