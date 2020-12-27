#!/usr/bin/env bash

source ~/.photon/tools/images/image/actions.sh

function image() {
  clear -x

  file=$1
  image_index=$2

  ui_header "IMAGE $SEP $file"

  if test -f "$file";
  then
    getExif "$file"
    mimetype="$(file -b -i "$file")"

    w=$(tput cols)
    w=$((w - 1))
    h=$(tput lines)
    # h=$((h / 2))

    chafa -c 240 -s "$wx$h" "$file"

    echo
    h1 "$file"
    img_dt=$(date -d"$( getExifValue "DateTimeOriginal" | tr ":" " " |  awk '{printf "%s/%s/%s %s:%s:%s", $2, $3, $1, $4, $5, $6}' )" )
    echo " $img_dt"

    hr
    echo " $( getExifValue "ImageWidth" ) ${fgg08}x${txReset} $( getExifValue "ImageHeight" ) ${fgg08}[${txReset} $( getExifValue "FileSize" ) ${fgg08}]${txReset}"
    echo -n " $( getExifValue "Make" ) $SEP $( getExifValue "Model" )"
    echo " $SEP $( getExifValue "Aperture" ) $SEP $( getExifValue "ShutterSpeed" ) $SEP $( getExifValue "FocalLength" )"
    hr

    echo
    exif_keyvalue Title
    exif_keyvalue Description
    exif_keyvalue Notes
    exif_keyvalue Subject
    exif_keyvalue Rating
    exif_keyvalue Colorlabels
    exif_keyvalue Creator
    exif_keyvalue Publisher
    exif_keyvalue Copyright

    image_actions
  else
    h1 "image not found"
  fi
  tab_title
}

function exif_keyvalue() {
    echo " ${fgg12}$1 $SEP $( getExifValue "$1" ) "
}
