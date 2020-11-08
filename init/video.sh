#!/bin/sh

sudo apt install -y ffmpeg

# sudo apt install -y shotcut

#install snapd first
# https://shotcut.org/download/
snap install shotcut --classic
sudo apt install -y melt

sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install -y obs-studio

sudo add-apt-repository ppa:kdenlive/kdenlive-stable
sudo apt-get update
sudo apt install -y kdenlive
