#!/bin/sh

cd ~
ln -sf ~/.photon/.atom

# install atom
sudo apt install -y atom

apm install package-sync

atom
