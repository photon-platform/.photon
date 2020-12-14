#!/usr/bin/env bash

source ~/.photon/tools/images/image/actions.sh

function image() {
  clear


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
    exiftool -imagewidth "$file"
    exiftool -imageheight "$file"
    # exiftool -imagesize "$file"
    exiftool -datetimeoriginal "$file"
    hr
    exiftool -title "$file"
    exiftool -image-description "$file"
    exiftool -copyright "$file"

    echo
    image_actions
  else
    h1 "image not found"
  fi
  tab_title

}

function getExif() {
  type="$1"
  cmd="exiftool -$type '$img'"
  result=$(eval $cmd)
  IFS=':'
  read -ra arr <<< "$result"
  IFS=' '
  echo "${arr[1]# }"
}

