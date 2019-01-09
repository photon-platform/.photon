#!/bin/sh

cd ~
ln -sf ~/.photon/.atom

# install atom dependencies
sudo apt install -y gconf-service gconf-service-backend gconf2 gconf2-common libgconf-2-4

# install atom
sudo apt install -y atom

apm install package-sync

atom
