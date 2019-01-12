#!/bin/sh

CHROME=google-chrome-stable_current_amd64.deb

cd ~/Downloads

wget https://dl.google.com/linux/direct/$CHROME

sudo dpkg -i $CHROME

rm $CHROME
