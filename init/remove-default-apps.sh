#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "remove default apps"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub gnome-contacts 
sudo apt -y remove gnome-contacts

sub geary
sudo apt -y remove geary

sub gnome-calendar 
sudo apt -y remove gnome-calendar

sub cleanup
sudo apt -y autoremove

sub "remove default apps complete"
elapsed_time $SECTION_TIME

