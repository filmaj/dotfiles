#!/bin/bash
set -xe

# TODO: this whole thing seemed like a good idea at first but now I get the feeling that ansible would be better for this.

# ssh keys + config in place?
(test -e ~/.ssh/id_rsa.pub && grep jaXVXHL ~/.ssh/id_rsa.pub &> /dev/null) || (echo "are your ssh keys in place duder?" && exit 1)

mypath=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

distro=$(uname -s)
# Homebrew / apt basics.
if [ "$distro" = "Darwin" ]; then
    test -x "$(command -v brew)" || echo "installing homebrew...." && bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";
    brew update;
    echo "Attempting to prompt to install xcode CLI tools, or print out installed location of tools. An error here is not catastrophic, relax.";
    xcode-select --install || xcode-select -p;
elif [ "$distro" = "Linux" ]; then
    sudo apt-get update;
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "zsh installed. rerun this ($0) now."
    exit 0
fi

# Update submodules in this repo
git submodule update --init

# Linking up zsh / vim things.
ln -snf "$mypath/.vim" ~/.
ln -snf "$mypath/.vimrc" ~/.
if ! [ -L ~/.zshrc ]; then
    rm -f ~/.zshrc
    ln -snf "$mypath/.zshrc" ~/.
fi
ln -snf "$mypath/.gitconfig" ~/.
ln -snf "$mypath/themes/spaceship-zsh-theme/spaceship.zsh-theme" ~/.oh-my-zsh/themes/.
test -L ~/.oh-my-zsh/custom/plugins || (rm -rf ~/.oh-my-zsh/custom/plugins && ln -s "$mypath/plugins" ~/.oh-my-zsh/custom/.)

# ack for greping shiet
test -x "$(command -v ack)" || install ack

# tmux!
test -x "$(command -v tmux)" || install tmux

# this is on the $PATH in .zshrc, is where i put built shit
mkdir -p ~/.local

# Python and its package manager
# TODO: maybe put this behind a "do u want python? y/n"
install python
# brew installs pip w/ python, apt-get does not.
test -x "$(command -v pip)" || ([ "$distro" = "Linux" ] && sudo apt-get install -y python-pip) || [ "$distro" = "Darwin" ]
test -x "$(command -v pyflakes)" || pip3 install --user pyflakes
test -x "$(command -v aws)" || pip3 install --user awscli
# node.js stuff
install nvm
# vim stuff
install vim
install fzf

if [ "$distro" = "Darwin" ]; then
    # set insanely high key repeat value in Mac. aint got time for slow shiet!
    defaults write NSGlobalDomain KeyRepeat -int 2
    brew install diff-so-fancy
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    # TODO: can probably import iterm2 preferences via plist files. steal from https://github.com/mitsuhiko/dotfiles/tree/master/iterm2
    echo "gonna run java so you can open oracle site and download the JRE and JDK. manually. like the pitiful human that you are."
    java -version
    echo "go set JAVA_HOME in .zshrc"
    echo "import the color palette into iterm"
fi
