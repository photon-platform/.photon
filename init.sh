#!/bin/sh

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

title() {
  clear -x
  echo "${orange}*************************************************"
  echo "${white}$1"
  echo "${orange}*************************************************"
  echo "${reset}"
}


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

title "Part 1 - complete"
atom -v
apm list
apache2 -v
php -v
composer -v
git -v
git config --list

echo
echo "${orange}Continue?${reset}"
read continue


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
