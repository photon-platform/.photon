#!/bin/bash

source ~/.photon/.hosts

mkdir ~/SITES
mkdir ~/SITES/LOGS
mkdir ~/SITES/LOGS/grav
cd ~/SITES

# read -p "continue?" tmp

wget https://getgrav.org/download/core/grav-admin/1.5.6 -O grav-admin-1.5.6.zip
unzip grav-admin-1.5.6.zip
mv grav-admin/ grav/

# git clone -b master https://github.com/getgrav/grav.git
# cd grav
# composer install --no-dev -o
# bin/grav install

# read -p "continue?" tmp


sudo cp ~/.photon/templates/grav.conf /etc/apache2/sites-available/grav.conf

sudo a2ensite grav.conf

addhost grav

cd grav

sudo chown -R phi:phi .
find . -type f | sudo xargs chmod 664
find ./bin -type f | sudo xargs chmod 775
find . -type d | sudo xargs chmod 775
find . -type d | sudo xargs chmod +s

sudo apache2ctl restart

open http://grav.local
