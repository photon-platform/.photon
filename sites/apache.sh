#!/usr/bin/env bash

# creates new apache confguration
# log directories
# enable site
# restart

function apache_new() {
    
  if [ $1 ]
  then
    sudo pwd

    echo
    echo "✴ create conf file:"
    sudo sed -e "s/grav/$1/g" /etc/apache2/sites-available/grav.conf | \
        sudo tee /etc/apache2/sites-available/$1.conf

    cat /etc/apache2/sites-available/$1.conf

    mkdir ~/SITES/LOGS/$1

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
    echo "specify project name: apache_new my-web"
  fi
}
