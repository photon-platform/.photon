#!/bin/bash

source ~/.photon/.hosts

mkdir -p ~/SITES/LOGS/grav
cd ~/SITES

# read -p "continue?" tmp
# https://getgrav.org/download/core/grav/1.6.20
GRAV=1.6.20
wget https://getgrav.org/download/core/grav/${GRAV} -O grav.zip
unzip -q grav.zip
# mv grav-admin/ grav/

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
