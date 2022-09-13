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

df . | tee -a $LOG

# set up symlinks for config files
source ~/.photon/home.sh
#set environment
source ~/.bashrc

title "disable .profile"
mv_bak ~/.profile


title "change hostname"
host_name=$(ask_value 'set system name' 'photon')
sudo hostnamectl set-hostname $host_name

source ~/.photon/init/gsettings.sh
source ~/.photon/init/remove-default-apps.sh
source ~/.photon/init/update-system.sh

source ~/.photon/init/git.sh
source ~/.photon/init/general.sh
source ~/.photon/init/python.sh
source ~/.photon/init/vim.sh
source ~/.photon/init/chrome.sh
source ~/.photon/init/node.sh
source ~/.photon/init/graphics.sh
source ~/.photon/init/media.sh

title "final update & upgrade"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"
sudo apt update -y && sudo apt upgrade -y

sub "final upgrade complete"
elapsed_time $SECTION_TIME
if $PAUSE; then pause_enter; fi



#####################################

# END_TIME="$(date -u +%s)"
# ELAPSED="$(($END_TIME-$START_TIME))"
# TIME=$(convertsecstomin $ELAPSED)

echo
# sub "elapsed: ${txBold}$TIME${txReset} m:s"
elapsed_time $START_TIME

df . | tee -a  $LOG


echo install manually:
echo - pandoc.sh 
echo - latex.sh
echo - thunderbird.sh
echo - epub.sh
echo
echo $fgRed reboot system
echo
