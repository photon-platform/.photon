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

# sudo add-apt-repository ppa:obsproject/obs-studio
# sudo apt update
# sudo apt install -y obs-studio

# sudo add-apt-repository ppa:kdenlive/kdenlive-stable
# sudo apt-get update
# sudo apt install -y kdenlive
