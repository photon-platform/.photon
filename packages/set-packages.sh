#!/usr/bin/env bash
sudo apt-get install dselect
sudo dpkg --set-selections < pkglist.txt
sudo apt-get dselect-upgrade
