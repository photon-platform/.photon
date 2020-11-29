#!/bin/bash

# remove all existing thumbnails
find $1 -type f -iname "th_*.jpg" -execdir rm {} \;
find $1 -type f -iname "wb_*.jpg" -execdir rm {} \;

# find $1 -type f -iname "*.jpg" -execdir magick {} -thumbnail 120x120^ thumbnail_{} \;

find $1 -type f -iname "*.jpg" -execdir magick {} -resize 1920  wb_{} \;
find $1 -type f -iname "wb_*.jpg" -execdir magick {} -resize 300  th_{} \;
