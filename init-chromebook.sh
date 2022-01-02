#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/.functions
LOGMD=~/init.log.md

title() {
  clear -x
  ui_banner "$1"

  echo 
}
subtitle() {
  echo
  h1 "$1"
  echo
}

cd ~/.photon

title "photon PLATFORM • chromebook initialization"
sudo pwd

./home.sh
source ~/.bashrc

title "update system packages"

echo
h1 "apt update"
echo
sudo apt update -y

echo
h1 "apt upgrade"
echo
sudo apt upgrade -y
echo
h1 "apt autoremove"
echo
sudo apt autoremove -y


init/git.sh

init/general.sh

init/vim.sh



title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y


subtitle "git"
git --version
# git config --list

subtitle "vim"
vim --version

subtitle "python"
python3 --version


#####################################

title "disable .profile"
mv_bak ~/.profile

title "change hostname"
sudo hostnamectl set-hostname 'photon'

echo $fgRed reboot system
echo
