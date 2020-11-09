#!/bin/sh

source ~/.photon/ui/_main.sh
source ~/.photon/.functions

reset=$(tput sgr0);
orange=$(tput setaf 166);
white=$(tput setaf 15);

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

clear -x

title "photon PLATFORM initialization"
h1 "press enter to continue"
read continue

START_TIME="$(date -u +%s)"
echo started: $(date +"%T")

subtitle "home bash settings"
./home.sh
src

subtitle "remove default apps"
init/remove-default-apps.sh

subtitle "update system packages"
sudo apt_upgrade

subtitle "preopen firefox"
firefox &

subtitle "gnome settings"
init/gsettings.sh


init/vim.sh

init/general.sh

# title "atom"
# init/atom.sh

title "apache"
init/apache.sh

title "php"
init/php.sh

# TODO: prompt user for info at start
# this script is hardcoded for phi
# title "git config"
# init/git.sh

title "grav base"
init/grav.sh

title "photon starter"
init/starter.sh

####################################
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

title "chrome"
init/chrome.sh


# title "virtualbox config"
# init/vbox-init.sh

# title "thunderbird"
# init/thunderbird.sh

# title "neomutt"
# init/neomutt.sh


# title "graphics"
# init/graphics.sh


title "update & upgrade"
sudo apt update -y && sudo apt upgrade -y

#####################################

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
composer -V

subtitle "git"
git --version
git config --list

subtitle "vim"
vim --version

# subtitle "inkscape"
# inkscape -V

# subtitle "gimp"
# gimp -v

# subtitle "darktable"
# darktable --version

# chrome -v

END_TIME="$(date -u +%s)"
ELAPSED="$(($END_TIME-$START_TIME))"

convertsecstomin() {
 ((m=${1}/60))
 ((s=${1}%60))
 printf "%02d:%02d\n" $m $s
}

TIME=$(convertsecstomin $ELAPSED)

subtitle "✴ elapsed: $TIME m:s"
