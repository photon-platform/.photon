#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "apache"

echo
h1 "apache2"
echo
sudo apt install -y apache2

echo
h1 "set user group"
echo
sudo usermod -a -G www-data $USERNAME

#set apache environment variables
sudo sed -i "s/^\(\s*export APACHE_RUN_USER=\s*\).*/\1$USERNAME/" /etc/apache2/envvars
sudo sed -i "s/^\(\s*export APACHE_RUN_GROUP=\s*\).*/\1$USERNAME/" /etc/apache2/envvars

sudo systemctl restart apache2

firefox "http://localhost" &
