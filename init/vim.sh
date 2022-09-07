#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

title "vim"
if $PAUSE; then pause_enter; fi

sub "build-essential cmake for YouCompleteMe"
sudo apt install -y build-essential cmake 
cmake --version | tee -a $LOG

sub "exuberant-ctags"
sudo apt install -y exuberant-ctags
ctags --version | tee -a $LOG

sub "python3-dev"
sudo apt install -y python3-dev

sub "vim-gtk3"
# enables + register for system clipboard
# and support for python
sudo apt install -y vim-gtk3
vim --version | tee -a $LOG

sub "clone .vim"

cd $HOME
D=$(date +"%Y%m%d-%T")

if [[ -e $HOME/.vim ]]; then
    echo mv ~/.vim ~/.vim.$D.bak
    mv $HOME/.vim $HOME/.vim.$D.bak
fi
git clone git@github.com:photon-platform/.vim --recurse-submodules

sub "install fzf"
cd ~/.vim/photon/fzf-util
./install --all
fzf --version | tee -a $LOG

sub "build photon-vim-completion"
cd ~/.vim/photon/completion
git submodule update --init --recursive
python3 install.py

sub "vim complete"
