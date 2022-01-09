#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "remove default apps"

echo
h1 gnome-contacts 
echo
sudo apt -y remove gnome-contacts

echo
h1 geary
echo
sudo apt -y remove geary

echo
h1 gnome-calendar 
echo
sudo apt -y remove gnome-calendar

# echo
# h1 firefox
# echo
# sudo apt -y remove firefox

echo
h1 cleanup
echo
sudo apt -y autoremove


