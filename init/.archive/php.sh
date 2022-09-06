#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "php"

echo
h1 "php"
echo
sudo apt install -y php
# this currently installs:
# libapache2-mod-php7.2
# php-common
# php7.2
# php7.2-cli
# php7.2-common
# php7.2-json
# php7.2-opcache
# php7.2-readline

echo
h1 "php accessories"
echo
sudo apt install -y \
  php-mbstring \
  php-xmlrpc \
  php-soap \
  php-gd \
  php-xml \
  php-curl \
  php-zip \
  php-pear \
  php-fpm \
  php-dev \
  php-mysql \
  php-apcu \
  php-tidy

echo
h1 "sqlite"
echo
sudo apt install -y \
  sqlite \
  php-pdo \
  php-sqlite3 

echo
h1 "php configure"
echo
sudo a2enmod proxy proxy_fcgi rewrite
sudo a2enconf php7.2-fpm
sudo a2enmod proxy_fcgi setenvif

sudo chmod  o+w /var/www/html

sudo echo "<?php phpInfo();" > /var/www/html/info.php
firefox "http://localhost/info.php"

