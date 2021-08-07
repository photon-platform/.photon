#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/.functions

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

title "photon PLATFORM initialization"
sudo pwd

./home.sh
source ~/.bashrc

init/remove-default-apps.sh

title "update system packages"

echo
h1 "apt update"
echo
sudo apt update -y

echo
h1 "apt upgradeable"
echo
sudo apt list --upgradeable

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

init/gsettings.sh

init/git.sh

init/general.sh

init/vim.sh

# subtitle "preopen firefox"
# firefox &

init/apache.sh

init/php.sh

init/composer.sh

init/grav.sh

init/starter.sh

title "chrome"
init/chrome.sh

# title "thunderbird"
# init/thunderbird.sh

# title "neomutt"
# init/neomutt.sh

init/graphics.sh

init/media.sh

init/thunderbird.sh

init/node.sh

# init/nextcloud.sh

title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y


subtitle "apache2"
apache2 -v

subtitle "php"
php -v

subtitle "composer"
composer -V

subtitle "git"
git --version
# git config --list

subtitle "vim"
vim --version

subtitle "inkscape"
inkscape -V

subtitle "gimp"
gimp -v

subtitle "darktable"
darktable --version

subtitle "google-chrome"
google-chrome --version

subtitle "firefox"
firefox --version


#####################################

title "disable .profile"
cp_bak ~/.profile

title "change hostname"
sudo hostnamectl set-hostname 'photon'

echo $fgRed reboot system
