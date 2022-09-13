#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

title "media"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "v4l2loopback"
sudo apt install -y v4l2loopback-dkms
sudo modprobe v4l2loopback video_nr=6 card_label=photon
sudo apt install -y v4l-utils

sub "pavucontrol"
sudo apt install -y pavucontrol
pavucontrol --version | tee -a $LOG

sub "ffmpeg"
sudo apt install -y ffmpeg
ffmpeg -version | tee -a $LOG

sub "gphoto2"
sudo apt install -y gphoto2
gphoto2 --version | tee -a $LOG

sub "mpv"
sudo apt install -y mpv
mpv --version | tee -a $LOG

sub "audacity"
sudo apt install -y audacity
audacity --version | tee -a $LOG

sub "flac"
sudo apt install -y flac
flac --version | tee -a $LOG


# echo
# sub "jack"
# echo
# sudo apt install -y jack

#install snapd first
# https://shotcut.org/download/
sub "snapd"
sudo apt install -y snapd
snap --version | tee -a $LOG

sub "shotcut"
snap install shotcut --classic
shotcut --version | tee -a $LOG

sub "melt"
sudo apt install -y melt
melt --version | tee -a $LOG

sub "midicsv"
sudo apt install -y midicsv
midicsv --version | tee -a $LOG

sub "timidity"
sudo apt install -y timidity
timidity --version | tee -a $LOG

sub "losslesscut"
sudo snap install losslesscut
losslesscut --version | tee -a $LOG

# sub "lmms"
# sudo apt install -y lmms

sub "youtube-dl"
sudo pip install --upgrade youtube-dl
youtube-dl --version | tee -a $LOG

sub "media complete
elapsed_time $SECTION_TIME
