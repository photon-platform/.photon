#!/bin/sh

init/remove-default-apps.sh
sudo apt update -y && sudo apt upgrade -y

init/atom.sh

init/apache.sh

init/php.sh

init/git.sh

init/vbox-init.sh

sudo apt install -y vim
# **ctags** Combining vim with ctags yields a powerful combination for working with large or unfamiliar codebases.

init/gsettings.sh

echo
echo *****************************************
echo
atom -v
apm list
apache2 -v
php -v
git -v
vim -v
