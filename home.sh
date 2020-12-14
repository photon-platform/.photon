#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
D=$(date +"%Y%m%d-%T")

clear -x
ui_banner "link config files in home directory"

function set_rc() {
  echo
  h1 $1
  echo
  if [[ -f ~/$1 ]]; then
    echo mv ~/$1 ~/$1.$D.bak
    mv ~/$1 ~/$1.$D.bak
  fi
  echo ln -sf ~/.photon/$1 ~/$1
  ln -sf ~/.photon/$1 ~/$1
}

set_rc .bashrc

set_rc .bash_profile

set_rc .vimrc

set_rc .vim

set_rc .config/ranger 
set_rc .config/sxiv

set_rc .XCompose
set_rc .Xresources
xrdb -load .Xresources

