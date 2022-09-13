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

source ~/.photon/init/remove-default-apps.sh

title "update system packages"
if $PAUSE; then pause_enter; fi

sub "apt update"
sudo apt update -y

sub "apt upgradeable"
apt list --upgradeable | tee -a $LOG

sub "apt upgrade"
sudo apt upgrade -y

sub "apt autoremove"
sudo apt autoremove -y

sub "system update complete"

source ~/.photon/init/gsettings.sh

source ~/.photon/init/git.sh

source ~/.photon/init/general.sh

source ~/.photon/init/python.sh

source ~/.photon/init/vim.sh

source ~/.photon/init/chrome.sh

source ~/.photon/init/node.sh

source ~/.photon/init/graphics.sh

source ~/.photon/init/media.sh


title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y

if $PAUSE; then pause_enter; fi



#####################################

title "disable .profile"
mv_bak ~/.profile

title "change hostname"
sudo hostnamectl set-hostname 'photon'

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
