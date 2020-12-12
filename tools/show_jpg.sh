#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

file="$1"


chafa -c 240 "$file"

h1 "$file"
hr

exiftool -imagesize "$file"
exiftool -creationdate "$file"

hr

exiftool -title "$file"
exiftool -image-description "$file"
exiftool -copyright "$file"
