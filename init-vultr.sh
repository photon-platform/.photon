#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions


LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

clear -x
title "VULTR init"

sudo pwd

if $(ask_truefalse "Pause at each step?")
then
  PAUSE=true
else
  PAUSE=false
fi

collect_system_metrics
write_installed_packages "start"

# set up symlinks for config files
function set_rc() {
  sub "$1"
  if [[ -e $HOME/$1 ]]; then
    echo mv ~/$1 ~/$1.$D.bak
    mv $HOME/$1 $HOME/$1.$D.bak
  fi
  echo ln -sf ~/.photon/$1 ~/$1
  ln -sf $HOME/.photon/$1 $HOME/$1
}

# set_rc .bashrc
echo "source ~/.photon/.bashrc" >> ~/.bashrc

set_rc .config/ranger 
# set_rc .config/sxiv
# set_rc .config/mpv

set_rc .XCompose
set_rc .Xresources
# xrdb -load .Xresources

#set environment
# source ~/.bashrc

# source ~/.photon/init/remove-default-apps.sh

collect_system_metrics
write_installed_packages "update"

# git clone git@github.com:phiarchitect/.private $HOME/.private

source ~/.photon/init/pyenv.sh
source ~/.photon/init/python.sh
source ~/.photon/init/python-huggingface.sh

source ~/.photon/init/git.sh
source ~/.photon/init/vim.sh
# source ~/.photon/init/chrome.sh
# source ~/.photon/init/node.sh
# source ~/.photon/init/graphics.sh
# source ~/.photon/init/media.sh

title "final update & upgrade"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"
sudo apt update -y && sudo apt upgrade -y

sub "final upgrade complete"
elapsed_time $SECTION_TIME | tee -a $LOG
if $PAUSE; then pause_enter; fi


echo
sub "INIT complete"
elapsed_time $START_TIME | tee -a $LOG

collect_system_metrics
write_installed_packages "end"

# Compare installed package lists
echo "Comparing installed package lists:"
diff installed_packages_start.txt installed_packages_end.txt

echo install manually:
echo - pandoc.sh 
echo - latex.sh
echo - epub.sh
echo
echo $fgRed reboot system
echo
