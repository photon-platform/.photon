#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "graphics"

echo
h1 "imagemagick"
echo
sudo apt install -y imagemagick 

echo
h1 "jpegtran"
echo
sudo apt install libjpeg-turbo-progs

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

