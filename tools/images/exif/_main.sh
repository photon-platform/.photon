#!/usr/bin/env bash

source ~/.photon/tools/images/exif/actions.sh

function tools_exif() {
  clear -x

  file=$1
  image_index=$2

  ui_header "EXIF $SEP $file"

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
    echo " title $SEP $( getExifValue "Title" ) "
    echo " caption $SEP $( getExifValue "Description" )" 
    echo " alt-text $SEP $( getExifValue "Notes" )" 
    echo " subject $SEP $( getExifValue "Subject" )" 
    hr
    echo " rating $SEP $( getExifValue "Rating" )" 
    echo " labels $SEP $( getExifValue "Colorlabels" )" 
    hr
    echo " creator $SEP $( getExifValue "Creator" ) "
    echo " publisher $SEP $( getExifValue "Publisher" ) "
    echo " copyright $SEP $( getExifValue "Copyright" ) "

    tools_exif_actions
  else
    h1 "image not found"
  fi
  tab_title

}

function getExif() {
  unset -v  $( ( set -o posix ; set ) | grep exif_ | sed -n 's/\(.*\)\=(.*/\1/p' )
  file="$1"
  mapfile -t exif_data < <( exiftool "$file" -S )
}

function getExifValue() {
  key=$1
  value=$( printf "%s\n" "${exif_data[@]}"  | sed -n "/^$key\:/p" | sed "s/^$key\: \(.*\)/\1/" )
  if [[ $value != null ]]; then
    echo $value | sed 's/^"//' | sed 's/"$//'
  fi
}
function getExifValue2() {
  value=$( echo $exif_json | jq ".[0].$1" )
  if [[ $value != null ]]; then
    echo $value | sed 's/^"//' | sed 's/"$//'
  fi
}
