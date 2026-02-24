#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions


LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

clear -x
title "PHOTON init"
sub "Pop!_OS edition"

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


title "change hostname"
host_name=$(ask_value 'set system name' 'particle')
sudo hostnamectl set-hostname $host_name

new_hostname=$(hostname)
if [[ "$new_hostname" != "$host_name" ]]; then
    echo "Error: Failed to set the hostname to $host_name"
    pause_enter
    # exit 1
else
    echo "Hostname successfully changed to $host_name"
fi


# source ~/.photon/init/gsettings.sh
# source ~/.photon/init/remove-default-apps.sh
source ~/.photon/init/update-system.sh

collect_system_metrics
write_installed_packages "update"

source ~/.photon/init/general.sh
source ~/.photon/init/git.sh

git clone git@github.com:phiarchitect/.private $HOME/.private

# source ~/.photon/init/uv.sh
# source ~/.photon/init/pyenv.sh
source ~/.photon/init/python.sh

# VIM/NVIM
# we are switching to nvim - separate install logic coming later
# source ~/.photon/init/vim.sh
source ~/.photon/init/chrome.sh
# source ~/.photon/init/node.sh
source ~/.photon/init/graphics.sh
source ~/.photon/init/media.sh

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
