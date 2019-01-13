#!/bin/sh

function title() {
  clear
  echo *************************************************
  echo "$1"
  echo *************************************************
  echo
}

title "gnome settings"
init/gsettings.sh

title "home bash settings"
./home.sh
source ~/.photon/.bash_profile

title "remove default apps"
init/remove-default-apps.sh

title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y

title atom
init/atom.sh

title apache
init/apache.sh

title php
init/php.sh

title git
init/git.sh

title "grav base"
init/grav.sh

title "photon starter"
init/starter.sh

title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y


title "virtualbox config"
init/vbox-init.sh

title "vim"
sudo apt install -y vim
# **ctags** Combining vim with ctags yields a powerful combination for working with large or unfamiliar codebases.

title thunderbird
init/thunderbird.sh

title chrome
init/chrome.sh

title graphics
init/graphics.sh

title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y

title installed apps

atom -v
apm list
apache2 -v
php -v
composer -v
git -v
git config --list
vim -v
inkscape -v
gimp -v
darktable -v
chrome -v
