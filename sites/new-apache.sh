#!/usr/bin/env bash

# creates new apache confguration
# log directories
# enable site
# restart

source ~/.photon/.hosts
source ~/.photon/.sites

if [ $1 ]
then
  sudo pwd

  echo
  echo "✴ create conf file:"
  sudo sed -e "s/starter/$1/g" /etc/apache2/sites-available/starter.conf | \
      sudo tee /etc/apache2/sites-available/$1.conf

  # cat /etc/apache2/sites-available/$1.conf

  echo
  echo "✴ enable site"
  sudo a2ensite $1

  echo
  echo "✴ add host"
  addhost $1

  echo
  echo "✴ restart apache"
  sudo apache2ctl restart
else
  echo "specify project name: new-apache my-web"
fi
