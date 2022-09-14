#!/usr/bin/env bash

# source ~/.photon/ui/_main.sh

# clear -x
title "graphics"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "imagemagick"
sudo apt install -y imagemagick 

sub "exif"
sudo apt install -y exif exiftool

sub "sxiv"
sudo apt install -y sxiv

sub "chafa"
sudo apt install -y chafa

# sub "jpegtran"
# sudo apt install libjpeg-turbo-progs

# sub "caca"
# sudo apt install -y caca-utils


sub "inkscape"
sudo apt install -y inkscape

sub "darktable"
sudo apt install -y darktable

sub "gimp"
sudo apt install -y gimp

sub "graphics complete"
elapsed_time $SECTION_TIME | tee -a $LOG
