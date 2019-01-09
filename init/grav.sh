#!/bin/sh

mkdir ~/SITES
cd ~/SITES

wget https://getgrav.org/download/core/grav-admin/1.5.6 -O /var/www/grav-admin-1.5.6.zip
unzip grav-admin-1.5.6.zip
mv grav-admin grav

cp ~/.photon/templates/grav.conf /etc/apache2/sites-available/grav.conf

sudo a2ensite grav.conf
sudo systemctl restart apache2

open grav.local
