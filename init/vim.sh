#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "vim"

echo
h1 "cmake"
echo
sudo apt install -y cmake #for YouCompleteMe

echo
h1 "exuberant-ctags"
echo
sudo apt install -y exuberant-ctags

echo
h1 "vim"
echo
sudo apt install -y vim
# enables + register for system clipboard
sudo apt install -y vim-gtk3

echo
h1 "install Vundle plugins"
echo
vim +PluginInstall +qall
