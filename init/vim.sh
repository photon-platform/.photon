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
sudo apt install -y vim-gtk

# echo
# h1 "install Vundle plugins"
# echo
# vim +PluginInstall +qall
git clone git@github.com:photon-platform/.vim --recurse-submodules
~/.vim/set_vimrc.sh

# build YouCompleteMe util
cd ~/.vim/photon/completion
git submodule update --init --recursive
python3 install.py
