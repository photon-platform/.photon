#!/bin/sh

# install atom dependencies
sudo apt install gconf-service gconf-service-backend gconf2 gconf2-common libgconf-2-4

# install atom
wget https://atom.io/download/deb -O atom.deb
sudo dpkg -if atom.deb
rm atom.deb
