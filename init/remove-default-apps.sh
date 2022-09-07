#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "remove default apps"
if $PAUSE; then pause_enter; fi

h1 gnome-contacts 
sudo apt -y remove gnome-contacts

h1 geary
sudo apt -y remove geary

h1 gnome-calendar 
sudo apt -y remove gnome-calendar

h1 cleanup
sudo apt -y autoremove


