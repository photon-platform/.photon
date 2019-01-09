#!/bin/sh

# install atom dependencies
sudo apt install gconf-service gconf-service-backend gconf2 gconf2-common libgconf-2-4

cd ~
ln -sf ~/.photon/.atom

# install atom
sudo apt install atom
