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
h1 "vim"
echo
# sudo apt install -y vim

# # enables + register for system clipboard
sudo apt install -y vim-nox

cd ~
D=$(date +"%Y%m%d-%T")

if [[ -e ~/.vim ]]; then
    echo mv ~/.vim ~/.vim.$D.bak
    mv ~/.vim ~/.vim.$D.bak
fi
git clone git@github.com:photon-platform/.vim --recurse-submodules
~/.vim/set_vimrc.sh

echo
h1 "build photon-vim-completion"
echo
# build YouCompleteMe util
cd ~/.vim/photon/completion
git submodule update --init --recursive
python3 install.py
