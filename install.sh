#!/bin/sh

# TODO: did you put your ssh keys + config in place?

# Installs oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Pathogen (bundle management for vim)
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git submodule update --init
ln -s .vimrc ~/.
ln -s .vim ~/.
ln -s .ondirrc ~/.
ln -s .gitconfig ~/.
# TODO:
# install pyflakes
# install ondir
# install android sdks
# java?
echo "Install pyflakes, ondir, android sdks into $HOME/sdks/android/sdk"
echo "whats the java deal? should set JAVA_HOME in .zshrc"
echo "virtualenvburrito?"
# theres some commented stuff stubbed in .zshrc
echo "you probably need to create an AOSP disk"
