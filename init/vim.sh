#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "vim"

echo
h1 "build-essential cmake for YouCompleteMe"
echo
sudo apt install -y build-essential cmake 

echo
h1 "exuberant-ctags"
echo
sudo apt install -y exuberant-ctags

echo
h1 "python3-dev"
echo
sudo apt install -y python3-dev

echo
h1 "vim-gtk"
echo
# enables + register for system clipboard
# and support for python
sudo apt install -y vim-gtk

echo
h1 "clone .vim"
echo

cd $HOME
D=$(date +"%Y%m%d-%T")

if [[ -e $HOME/.vim ]]; then
    echo mv ~/.vim ~/.vim.$D.bak
    mv $HOME/.vim $HOME/.vim.$D.bak
fi
git clone git@github.com:photon-platform/.vim --recurse-submodules

echo
h1 "install fzf"
echo
cd ~/.vim/photon/fzf-util
./install --all

echo
h1 "build photon-vim-completion"
echo
# build YouCompleteMe util
cd ~/.vim/photon/completion
git submodule update --init --recursive
python3 install.py
