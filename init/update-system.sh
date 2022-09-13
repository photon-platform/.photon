#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "update system"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "apt update"
sudo apt update -y

sub "apt upgradeable"
apt list --upgradeable | tee -a $LOG

sub "apt upgrade"
sudo apt upgrade -y

sub "apt autoremove"
sudo apt autoremove -y

sub "update system comlete"
elapsed_time $SECTION_TIME

