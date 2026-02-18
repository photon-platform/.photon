#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions


LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

clear -x
title "photon PLATFORM initialization"

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
source ~/.photon/home.sh

#set environment
source ~/.bashrc

title "disable .profile"
mv_bak ~/.profile

source ~/.photon/init/update-system.sh

collect_system_metrics
write_installed_packages "update"

source ~/.photon/init/general.sh
source ~/.photon/init/pyenv.sh
source ~/.photon/init/python.sh

source ~/.photon/init/git.sh
git clone git@github.com:phiarchitect/.private $HOME/.private

# source ~/.photon/init/vim.sh
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
