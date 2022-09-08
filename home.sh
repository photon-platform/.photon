#!/usr/bin/env bash

source $HOME/.photon/init/_utils.sh

D=$(date +"%Y%m%d-%T")

# clear -x
title "link config files in home directory"

function set_rc() {
  sub "$1"
  if [[ -e $HOME/$1 ]]; then
    echo mv ~/$1 ~/$1.$D.bak
    mv $HOME/$1 $HOME/$1.$D.bak
  fi
  echo ln -sf ~/.photon/$1 ~/$1
  ln -sf $HOME/.photon/$1 $HOME/$1
}

set_rc .bashrc

set_rc .bash_profile

set_rc .config/ranger 
set_rc .config/sxiv
set_rc .config/mpv

set_rc .XCompose
set_rc .Xresources
xrdb -load .Xresources

