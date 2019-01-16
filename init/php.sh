#!/bin/sh

# install php
sudo apt -y update
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

# for TNT search
sudo apt install -y \
  sqlite \
  php-pdo \
  php-sqlite3 \
  php-mysql

sudo a2enmod proxy proxy_fcgi rewrite
sudo a2enconf php7.2-fpm
sudo a2enmod proxy_fcgi setenvif

sudo chmod  o+w /var/www/html

sudo echo "<?php phpInfo();" > /var/www/html/info.php
firefox "http://localhost/info.php"

# composer

sudo apt install -y composer
sudo chown -R $USER $HOME/.composer
composer global require "asm89/twig-lint" "@dev"
#make sure this is in the path fconfig
export PATH=$PATH:~/.composer/vendor/asm89/twig-lint/bin
# twig-lint at command prompt to test
