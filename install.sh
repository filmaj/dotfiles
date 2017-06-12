#!/bin/bash
set -xe

# TODO: this whole thing seemed like a good idea at first but now I get the feeling that ansible would be better for this.

# ssh keys + config in place?
(test -e ~/.ssh/id_rsa.pub && grep maj.fil ~/.ssh/id_rsa.pub &> /dev/null) || (echo "are your ssh keys in place duder?" && exit 1)

mypath=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

distro=$(uname -s)
# Homebrew / apt basics.
if [ "$distro" = "Darwin" ]; then
    test -x "$(command -v brew)" || (echo "installing homebrew...." && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")
    brew update
    echo "Attempting to prompt to install xcode CLI tools, or print out installed location of tools. An error here is not catastrophic, relax."
    xcode-select --install || xcode-select -p
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

# Linking up zsh / vim things.
test -L ~/.vimrc || ln -s "$mypath/.vimrc" ~/.
if ! [ -L ~/.zshrc ]; then
    rm -f ~/.zshrc
    ln -s "$mypath/.zshrc" ~/.
fi
test -L ~/.vim/bundle || ln -s "$mypath/.vim/bundle" ~/.vim/.
test -L ~/.ondirrc || ln -s "$mypath/.ondirrc" ~/.
test -L ~/.gitconfig || ln -s "$mypath/.gitconfig" ~/.
test -L ~/.oh-my-zsh/themes/spaceship.zsh-theme || ln -s "$mypath/themes/spaceship-zsh-theme/spaceship.zsh-theme" ~/.oh-my-zsh/themes/.
test -L ~/.oh-my-zsh/custom/plugins || (rm -rf ~/.oh-my-zsh/custom/plugins && ln -s "$mypath/plugins" ~/.oh-my-zsh/custom/.)

# ctags for vim leetness
install ctags

# ack for greping shiet
test -x "$(command -v ack)" || install ack

# Python and its package manager
# TODO: maybe put this behind a "do u want python? y/n"
install python
# brew installs pip w/ python, apt-get does not.
test -x "$(command -v pip)" || ([ "$distro" = "Linux" ] && sudo apt-get install -y python-pip) || [ "$distro" = "Darwin" ]
pip install --user virtualenv
pip install --user virtualenvwrapper
test -x "$(command -v pyflakes)" || pip install --user pyflakes

# this is on the $PATH in .zshrc, is where i put built shit
mkdir -p ~/.local

if [ "$distro" = "Darwin" ]; then
    # set insanely high key repeat value in Mac. aint got time for slow shiet!
    defaults write NSGlobalDomain KeyRepeat -int 2
    # TODO: how to install these on linux?
    brew install ondir
    brew install vim
    brew install unrar
    brew install watch
    brew install pstree
    # you can install virtualbox and vagrant on mac with brew. amazeballs.
    # i stole the below from http://sourabhbajaj.com/mac-setup/ which is an amazing resource btw
    brew cask install virtualbox
    brew cask install vagrant
    brew cask install vagrant-manager
    # TODO: can probably import iterm2 preferences via plist files. steal from https://github.com/mitsuhiko/dotfiles/tree/master/iterm2
    echo "gonna run java so you can open oracle site and download the JRE and JDK. manually. like the pitiful human that you are."
    java -version
    echo "go set JAVA_HOME in .zshrc"
    echo "import the color palette into iterm"
fi
pushd ~/src
# building node.js from source because fuck it
if ! [ -d ~/src/node ]; then
    local node_version="v6.11.0"
    git clone --branch $node_version --single-branch git@github.com:nodejs/node.git
    pushd ~/src/node
    ./configure --prefix=$HOME/.local
    make -j4 # build based on a 4 core machine
    make install
    popd # ~/src
fi
popd # pwd
npm install -g eslint eslint-plugin-promise eslint-plugin-standard eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-config-semistandard
test -L ~/.eslintrc || ln -s "$mypath/.eslintrc.js" ~/.

mkdir -p ~/sdks
echo "maybe install android sdks? https://developer.android.com/studio/index.html?hl=sk"
# TODO what about android sdk?
