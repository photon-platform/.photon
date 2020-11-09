#!/usr/bin/env bash

GRAV=1.6.28

source ~/.photon/hosts/_main.sh
source ~/.photon/ui/_main.sh

clear -x
ui_banner "grav"

echo
h1 "download zip: $GRAV"
echo

mkdir -p ~/SITES/LOGS/grav
cd ~/SITES

wget https://getgrav.org/download/core/grav/${GRAV} -O grav.zip
unzip -q grav.zip

echo
h1 "set conf file"
echo
sudo cp ~/.photon/templates/grav.conf /etc/apache2/sites-available/grav.conf

sudo a2ensite grav.conf

addhost grav

cd grav

sudo chown ${USERNAME}:${USERNAME} -R .
find . -type f | sudo xargs chmod 664
find ./bin -type f | sudo xargs chmod 775
find . -type d | sudo xargs chmod 775
find . -type d | sudo xargs chmod +s

sudo apache2ctl restart

firefox "http://grav.local" &
