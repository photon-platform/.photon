#!/bin/sh

cd ~
ln -sf ~/.photon/.atom

# install atom
sudo apt install -y atom

# apm install package-sync

# install each item from the packages file
head -n -1 ~/.photon/.atom/packages.cson | sed -n "1d;p" | xargs apm install


atom ~/.photon
