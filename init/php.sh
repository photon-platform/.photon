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
