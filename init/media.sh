#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "media"

h1 "v4l2loopback"
echo
sudo apt install -y v4l2loopback-dkms
sudo modprobe v4l2loopback video_nr=6 card_label=photon
sudo apt install -y v4l-utils

echo
h1 "pavucontrol"
echo
sudo apt install -y pavucontrol

# echo
# h1 "jack"
# echo
# sudo apt install -y jack

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

# echo
# h1 "editly"
# echo
# sudo apt install -y \
  # build-essential \
  # libcairo2-dev \
  # libpango1.0-dev \
  # libjpeg-dev \
  # libgif-dev \
  # librsvg2-dev
# npm i -g canvas
# npm i -g editly

# echo
# h1 "timecut & timesnap"
# echo
# npm i -g timespan timecut


echo


