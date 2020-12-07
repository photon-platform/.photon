#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "graphics"

echo
h1 "imagemagick"
echo
sudo apt install -y imagemagick 

echo
h1 "exif"
echo
sudo apt install -y exif exiftool

echo
h1 "sxiv"
echo
sudo apt install -y sxiv

echo
h1 "chafa"
echo
sudo apt install -y chafa

echo
h1 "caca"
echo
sudo apt install -y caca-utils


echo
h1 "inkscape"
echo
sudo apt install -y inkscape

echo
h1 "darktable"
echo
sudo apt install -y darktable

echo
h1 "gimp"
echo
sudo apt install -y gimp

echo
h1 "python tools"
echo
sudo apt -y install python3-pip python3-setuptools python3-wheel

echo
h1 "rapid photo downloader"
echo
wget -O ~/Downloads/rapid-photo-downloader.py https://launchpad.net/rapid/pyqt/0.9.14/+download/install.py
python3 ~/Downloads/rapid-photo-downloader.py
rm ~/Downloads/rapid-photo-downloader.py


echo
h1 "librecad"
echo
sudo apt install -y librecad

echo
h1 "freecad"
echo
sudo apt install -y freecad

