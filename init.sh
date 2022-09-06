#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions

LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

title "photon PLATFORM initialization"

sudo pwd

df . >> $LOG

./home.sh
source ~/.bashrc

source ~/.photon/init/remove-default-apps.sh


title "update system packages"
if $PAUSE; then pause_enter; fi

h1 "apt update"
sudo apt update -y

h1 "apt upgradeable"
apt list --upgradeable | tee -a $LOG


h1 "apt upgrade"
if $PAUSE; then pause_enter; fi
sudo apt upgrade -y

h1 "apt autoremove"
if $PAUSE; then pause_enter; fi
sudo apt autoremove -y

if $PAUSE; then pause_enter; fi

source ~/.photon/init/gsettings.sh
if $PAUSE; then pause_enter; fi

source ~/.photon/init/git.sh
if $PAUSE; then pause_enter; fi

source ~/.photon/init/general.sh
if $PAUSE; then pause_enter; fi

source ~/.photon/init/python.sh
if $PAUSE; then pause_enter; fi

source ~/.photon/init/vim.sh
if $PAUSE; then pause_enter; fi

# title "chrome"
# init/chrome.sh

# init/node.sh

# init/graphics.sh

# init/media.sh


title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y

if $PAUSE; then pause_enter; fi



#####################################

title "disable .profile"
mv_bak ~/.profile

title "change hostname"
sudo hostnamectl set-hostname 'photon'

END_TIME="$(date -u +%s)"
ELAPSED="$(($END_TIME-$START_TIME))"
TIME=$(convertsecstomin $ELAPSED)

echo
h1 "elapsed: ${txBold}$TIME${txReset} m:s"

df . >> $LOG


echo install manually:
echo - pandoc.sh 
echo - latex.sh
echo - thunderbird.sh
echo - epub.sh
echo
echo $fgRed reboot system
echo
