#!/bin/sh
init/remove-default-apps.sh
sudo apt update && sudo apt upgrade

init/vbox-init.sh



# copy config files (from git?)

sudo apt install vim
# **ctags** Combining vim with ctags yields a powerful combination for working with large or unfamiliar codebases.


# install atom dependencies
sudo apt install gconf-service gconf-service-backend gconf2 gconf2-common libgconf-2-4

# install atom
wget https://atom.io/download/deb -O atom.deb
sudo dpkg -if atom.deb
rm atom.deb



# apache www folders
sudo usermod -a -G www-data phi

# install apache
sudo apt update
sudo apt install apache2
sudo systemctl status apache2

# install php
sudo apt update
sudo apt install php
# this currently installs:
# libapache2-mod-php7.2
# php-common
# php7.2
# php7.2-cli
# php7.2-common
# php7.2-json
# php7.2-opcache
# php7.2-readline

sudo apt install \
 php-mbstring\
 php-xmlrpc\
 php-soap\
 php-gd\
 php-xml\
 php-curl\
 php-zip\
 php-pear\
 php-fpm\
 php-dev\
 php-mysql\
 php-apcu\
 php-tidy

# for TNT search
sudo apt install sqlite
sudo apt install \
  php-pdo \
  php-sqlite3 \
  php-mysql

sudo a2enmod proxy proxy_fcgi rewrite
sudo a2enconf php7.2-fpm
a2enmod proxy_fcgi setenvif

cd /var/www
sudo wget https://getgrav.org/download/core/grav-admin/1.5.1 -O /var/www/grav-admin-1.5.1.zip
sudo unzip grav-admin-1.5.1.zip grav/

# set better permissions
sudo chmod -R 777 /var/www/grav
sudo chown -R www-data:www-data /var/www/grav

# configure git


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

php -S localhost:8000 system/router.php


# start agent
eval "$(ssh-agent -s)"

# set ssh keys
# copy keys into folder
# set directory to proper permissions
sudo chmod 700 ~/.ssh
# set private keys

# instructions for setting up an SSH key on inmotion_ssh
# https://www.inmotionhosting.com/support/website/ssh/shared-reseller-ssh
sudo chmod 600 ~/.ssh/inmotion_ssh
sudo ssh-add ~/.ssh/inmotion_ssh
# 'config' file should have alias for illumiphi.com
# connect to inmotion
ssh illumiphi.com

# for github
sudo chmod 600 ~/.ssh/id_rsa_phi_illumiphi
ssh-add ~/.ssh/id_rsa_phi_illumiphi
# use password from key creation







## git new keygen (if ncessary)
ssh-keygen -t rsa -b 4096 -C "phi@illumiphi.com"
# save to id_rsa_phi_illumiphi

# start agent
eval "$(ssh-agent -s)"
# add key to agent for single signon
ssh-add ~/.ssh/id_rsa_phi_illumiphi

# Copies the contents of the id_rsa.pub file to your clipboard - paste to github settings
sudo apt install xclip
xclip -sel clip < ~/.ssh/id_rsa_phi_illumiphi.pub


# Thunderbird
## to install most recent version of Mozilla Thunderbird, you can use the PPA maintained by the Mozilla team.
## Next, update the system software packages using update command.
## Once you’ve updated the system, install it using the following command.

    # sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa
    # sudo apt-get update
    sudo apt install thunderbird
    # install lightening extension for calendar

    sudo apt-get install terminator

# install Chrome (no easy commandline)


# install node
sudo apt install nodejs npm

sudo npm install -g node-sass

npm install -g hexo-cli

sudo npm install

npm rebuild node-sass --force


# install xpath
sudo apt install libxml-xpath-perl


# librecad


# composer

sudo apt install composer
sudo chown -R $USER $HOME/.composer
composer global require "asm89/twig-lint" "@dev"
#make sure this is in the path fconfig
export PATH=$PATH:~/.composer/vendor/asm89/twig-lint/bin
# twig-lint at command prompt to test
