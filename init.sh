#!/bin/sh

# source ~/.photon/.colors

reset=$(tput sgr0);
orange=$(tput setaf 166);
white=$(tput setaf 15);

title() {
  clear -x
  echo "${orange}*************************************************"
  echo "${white}$1"
  echo "${orange}*************************************************"
  echo "${reset}"
}

title "preopen firefox"
firefox &

title "ready to install - press enter to continue"
read continue

title "gnome settings"
init/gsettings.sh


title "home bash settings"
./home.sh
source ~/.photon/.bash_profile


title "atom"
init/atom.sh

title "apache"
init/apache.sh

title "php"
init/php.sh

title "git config"
init/git.sh

title "grav base"
init/grav.sh

title "photon starter"
init/starter.sh

# title "Part 1 - complete"
# atom -v
# apm list
# apache2 -v
# php -v
# composer -v
# git -v
# git config --list
#
# echo
# echo "${orange}Continue?${reset}"
# read continue


title "remove default apps"
init/remove-default-apps.sh

title "virtualbox config"
init/vbox-init.sh

title "thunderbird"
init/thunderbird.sh

title "chrome"
init/chrome.sh

title "graphics"
init/graphics.sh

title "vim"
sudo apt install -y vim
# **ctags** Combining vim with ctags yields a powerful combination for working with large or unfamiliar codebases.


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
