#!/usr/bin/env bash

source ~/.photon/tools/audios/audio/actions.sh

function audio() {
  clear -x

  file=$1
  audio_index=$2

  ui_header "AUDIO $SEP $( realpath "$file" )"

  if test -f "$file";
  then
    getExif "$file"

    mimetype="$(file -b -i "$file")"

    # ffmpeg -i "$file" -filter_complex "showwavespic=s=1920x1080" -frames:v 1 "$file.png"

    w=$(tput cols)
    w=$((w - 1))
    h=$(tput lines)
    # h=$((h / 2))

    h2 "$file"
    echo
    h1 "$( getExifValue "Title" )" 
    h2 "$( getExifValue "Artist" )" 
    h2 "$( getExifValue "Album" )" 
    echo

    hr
    echo " $( getExifValue "Duration" ) ${fgg08}[${txReset} $( getExifValue "FileSize" ) ${fgg08}]${txReset}"
    hr

    echo
    exif_keyvalue Title
    exif_keyvalue Artist
    exif_keyvalue Composer
    exif_keyvalue Album
    exif_keyvalue Genre
    exif_keyvalue TrackNumber
    exif_keyvalue DiskNumber
    exif_keyvalue Description
    exif_keyvalue Notes
    exif_keyvalue Subject
    exif_keyvalue Rating
    exif_keyvalue Colorlabels
    exif_keyvalue ContentCreateDate
    exif_keyvalue Creator
    exif_keyvalue Publisher
    exif_keyvalue Copyright

    audio_actions
  else
    h1 "audio not found"
  fi
  tab_title
}

function exif_keyvalue() {
    echo " ${fgg12}$1 $SEP $( getExifValue "$1" ) "
}
