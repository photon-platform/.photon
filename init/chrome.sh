#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

title "google chrome"
if $PAUSE; then pause_enter; fi

CHROME=google-chrome-stable_current_amd64.deb

cd ~/Downloads

wget https://dl.google.com/linux/direct/$CHROME

sudo dpkg -i $CHROME

rm $CHROME
