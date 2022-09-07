#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

# clear -x
title "graphics"
if $PAUSE; then pause_enter; fi

h1 "imagemagick"
sudo apt install -y imagemagick 

h1 "exif"
sudo apt install -y exif exiftool

h1 "sxiv"
sudo apt install -y sxiv

h1 "chafa"
sudo apt install -y chafa

# h1 "jpegtran"
# sudo apt install libjpeg-turbo-progs

# h1 "caca"
# sudo apt install -y caca-utils


h1 "inkscape"
sudo apt install -y inkscape

h1 "darktable"
sudo apt install -y darktable

h1 "gimp"
sudo apt install -y gimp

