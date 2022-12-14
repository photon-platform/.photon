#!/usr/bin/env bash

# PHOTON init - Vim
# subscript for installing and configuring vim
#
# pre-requisites installed:
# - build-essential
# - cmake
# - exuberant-ctags
# - python3-dev
#
# vim-gtk3 is a special build of vim with the Gnome Tool Kit.
# The primary benefit is access to the system clipboard from vim.
# 
# The .vim config directory is cloned with --recurse-submodules.
# I have moved from the plugin manager, Vundle, to simply adding 
# submodules to the repo directly
# 
# final steps build or install components for the plugins

# source ~/.photon/ui/_main.sh

TITLE="VIM install and configuration"

title "$TITLE"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

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
git clone git@github.com:photon-platform/vim --recurse-submodules .vim

sub "install fzf"
cd ~/.vim/photon/fzf-util
./install --all
source ~/.bashrc
fzf --version | tee -a $LOG

sub "build photon-vim-completion"
cd ~/.vim/photon/completion
git submodule update --init --recursive
python3 install.py

sub "$TITLE - COMPLETE"
elapsed_time $SECTION_TIME | tee -a $LOG
