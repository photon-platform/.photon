#!/usr/bin/env bash

source ~/.photon/tools/images/image/actions.sh

function image() {
  clear -x

  file=$1
  image_index=$2

  ui_header "IMAGE $SEP $file"

  if test -f "$file";
  then
    mimetype="$(file -b -i "$file")"

    w=$(tput cols)
    w=$((w - 1))
    h=$(tput lines)
    # h=$((h / 2))

    chafa -c 240 -s "$wx$h" "$file"

    echo
    h1 "$file"
    hr
    getExif "$file"
    echo " $( getExifValue "ImageWidth" ) x $( getExifValue "ImageHeight" )"
    echo " created $SEP $( getExifValue "DateTimeOriginal" ) "
    hr
    exif_keyvalue Title
    exif_keyvalue Description
    exif_keyvalue Notes
    exif_keyvalue Subject
    exif_keyvalue Rating
    exif_keyvalue Colorlabels
    exif_keyvalue Creator
    exif_keyvalue Publisher
    exif_keyvalue Copyright
    hr
    echo " $( getExifValue "Make" ) $SEP $( getExifValue "Model" )"
    echo " $( getExifValue "Aperture" ) $SEP $( getExifValue "ShutterSpeed" ) $SEP $( getExifValue "FocalLength" )"
    
    image_actions
  else
    h1 "image not found"
  fi
  tab_title
}

function exif_keyvalue() {
    echo " ${fgg12}$1 $SEP $( getExifValue "$1" ) "
  
}
