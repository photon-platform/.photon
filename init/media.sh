#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "media"

echo
h1 "jack"
echo
sudo apt install -y jack

echo
h1 "ffmpeg"
echo
sudo apt install -y ffmpeg

echo
h1 "gphoto2"
echo
sudo apt install -y gphoto2

echo
h1 "mpv"
echo
sudo apt install -y mpv

echo
h1 "audacity"
echo
sudo apt install -y audacity

#install snapd first
# https://shotcut.org/download/
echo
h1 "snapd"
echo
sudo apt install -y snapd

echo
h1 "shotcut"
echo
snap install shotcut --classic

echo
h1 "melt"
echo
sudo apt install -y melt

echo
h1 "lmms"
echo
sudo apt install -y lmms

echo
h1 "midicsv"
echo
sudo apt install -y midicsv

echo
h1 "timidity"
echo
sudo apt install -y timidity

echo
h1 "losslesscut"
echo
sudo snap install losslesscut

echo
h1 "editly"
echo
sudo apt-get install build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev
sudo npm i -g canvas
sudo npm i -g editly


echo
h1 "v4l2loopback"
echo
sudo apt install v4l2loopback-dkms
sudo modprobe v4l2loopback video_nr=6 card_label=photon
sudo apt install v4l-utils


