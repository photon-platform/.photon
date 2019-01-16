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
subtitle() {
  echo ""
  echo ""
  echo "${white}$1"
  echo "${orange}*************************************************"
  echo "${reset}"
}

title "ready to install - press enter to continue"
read continue

sudo apt update -y


title "preopen firefox"
firefox &


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

subtitle "atom"
atom -v

subtitle "apm list"
apm list

subtitle "apache2"
apache2 -v

subtitle "php"
php -v

subtitle "composer"
composer -v

subtitle "git"
git -v
git config --list

subtitle "vim"
vim --version

subtitle "inkscape"
inkscape -V

subtitle "gimp"
gimp -v

subtitle "darktable"
darktable -v

# chrome -v
