#!/bin/sh

# install apache
sudo apt install -y apache2
sudo systemctl status apache2

# apache www folders
sudo usermod -a -G www-data $USERNAME

#set apache environment variables
sudo sed -i "s/^\(\s*export APACHE_RUN_USER=\s*\).*/\1$USERNAME/" /etc/apache2/envvars
sudo sed -i "s/^\(\s*export APACHE_RUN_GROUP=\s*\).*/\1$USERNAME/" /etc/apache2/envvars
