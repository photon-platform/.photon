#!/bin/sh

mkdir ~/SITES
cd ~/SITES

sudo wget https://getgrav.org/download/core/grav-admin/1.5.6 -O /var/www/grav-admin-1.5.6.zip
sudo unzip grav-admin-1.5.6.zip grav/

# set better permissions
# sudo chmod -R 777 /var/www/grav
# sudo chown -R www-data:www-data /var/www/grav

# TODO:  set or clone new web folder

# add new available site .conf

cp /etc/apache2/sites-available/000-default.conf grav.conf
sudo gedit /etc/apache2/sites-available/grav.conf

#<VirtualHost grav:80>
#	#ServerName www.example.com
#
#	ServerAdmin phi@illumiphi.com
#	DocumentRoot /var/www/grav
#
#	#LogLevel info ssl:warn
#
#	ErrorLog ${APACHE_LOG_DIR}/error.log
#	CustomLog ${APACHE_LOG_DIR}/access.log combined
#
#</VirtualHost>

sudo a2ensite grav.conf
sudo systemctl restart apache2

open grav.local
