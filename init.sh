#!/usr/bin/env bash

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

init/remove-default-apps.sh

if PAUSE; then pause_enter; fi

title "update system packages"

echo
h1 "apt update"
echo
sudo apt update -y

echo
h1 "apt upgradeable"
echo
sudo apt list --upgradeable
sudo apt list --upgradeable >> $LOG

# echo
# read -n1 -p "run upgrade?" run_upgrade
# if [[ $run_upgrade == "y" ]]; then
  echo
  h1 "apt upgrade"
  echo
  sudo apt upgrade -y

  echo
  h1 "apt autoremove"
  echo
  sudo apt autoremove -y
# fi

if PAUSE; then pause_enter; fi

source init/gsettings.sh
if PAUSE; then pause_enter; fi

source init/git.sh
if PAUSE; then pause_enter; fi

source init/general.sh
if PAUSE; then pause_enter; fi

source init/python.sh
if PAUSE; then pause_enter; fi

source init/vim.sh
if PAUSE; then pause_enter; fi

# title "chrome"
# init/chrome.sh

# init/node.sh

# init/graphics.sh

# init/media.sh


title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y
if PAUSE; then pause_enter; fi




#####################################

title "disable .profile"
mv_bak ~/.profile

title "change hostname"
sudo hostnamectl set-hostname 'photon'

END_TIME="$(date -u +%s)"
ELAPSED="$(($END_TIME-$START_TIME))"
TIME=$(convertsecstomin $ELAPSED)

echo
h2 "elapsed: ${txBold}$TIME${txReset} m:s"

echo install manually:
echo - pandoc.sh 
echo - latex.sh
echo - thunderbird.sh
echo - epub.sh
echo
echo $fgRed reboot system
echo
