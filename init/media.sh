#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

title "media"

h1 "v4l2loopback"
sudo apt install -y v4l2loopback-dkms
sudo modprobe v4l2loopback video_nr=6 card_label=photon
sudo apt install -y v4l-utils

h1 "pavucontrol"
sudo apt install -y pavucontrol
pavucontrol --version | tee -a $LOG

h1 "ffmpeg"
sudo apt install -y ffmpeg
ffmpeg --version | tee -a $LOG

h1 "gphoto2"
sudo apt install -y gphoto2
gphoto2 --version | tee -a $LOG

h1 "mpv"
sudo apt install -y mpv
mpv --version | tee -a $LOG

h1 "audacity"
sudo apt install -y audacity
audacity --version | tee -a $LOG

# echo
# h1 "jack"
# echo
# sudo apt install -y jack

#install snapd first
# https://shotcut.org/download/
h1 "snapd"
sudo apt install -y snapd
snap --version | tee -a $LOG

h1 "shotcut"
snap install shotcut --classic
shotcut --version | tee -a $LOG

h1 "melt"
sudo apt install -y melt
melt --version | tee -a $LOG

# echo
# h1 "lmms"
# echo
# sudo apt install -y lmms

h1 "midicsv"
sudo apt install -y midicsv
midicsv --version | tee -a $LOG

h1 "timidity"
sudo apt install -y timidity
timidity --version | tee -a $LOG

h1 "losslesscut"
sudo snap install losslesscut
losslesscut --version | tee -a $LOG

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


h1 "youtube-dl"
sudo pip install --upgrade youtube-dl

