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

# mv .bashrc .bashrc.$D.bak
# ln -sf ~/.photon/home/.bashrc
set_rc .bashrc

# mv .bash_profile .bash_profile.$D.bak
# ln -sf ~/.photon/home/.bash_profile
set_rc .bash_profile

# mv .vimrc .vimrc.$D.bak
# ln -sf ~/.photon/.vimrc
set_rc .vimrc

# mv .vim .vim.$D.bak
# ln -sf ~/.photon/.vim
set_rc .vim

# mv .config/ranger .config/ranger.$D.bak
# ln -sf ~/.photon/config/ranger ~/.config/ranger
set_rc .config/ranger 

