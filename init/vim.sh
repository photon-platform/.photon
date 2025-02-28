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
sudo apt install -y build-essential 
pip install cmake
cmake --version | tee -a $LOG


sub "exuberant-ctags"
sudo apt install -y exuberant-ctags
ctags --version | tee -a $LOG

# sub "python3-dev"
# sudo apt install -y python3-dev

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

# Use pyenv to set a specific Python version for this build.
# This is the most reliable way to ensure compatibility.
# We're using 3.11 as an example; you might try 3.12 as well.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

pyenv install 3.11.7
pyenv local 3.11.7 # Or another supported version you have installed

# Update pybind11 to the latest version.
cd third_party/ycmd/cpp/pybind11
git fetch origin
git checkout origin/master  # Or the appropriate branch for the latest release
cd - # Go back to the previous directory

# Clean any previous build artifacts.
cd ~/.vim/photon/completion
rm -rf build

# Rebuild with the specified Python version.
python install.py


sub "$TITLE - COMPLETE"
elapsed_time $SECTION_TIME | tee -a $LOG
