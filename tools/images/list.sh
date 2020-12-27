#!/usr/bin/env bash

function images_list_get() {
  find . \
    -type f -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.tif" -o \
    -iname "*.gif"  \
     | sort | sed 's|\./||'
}

function images_list() {
  mapfile -t list < <( images_list_get )
  list_count=${#list[@]}

  i=1

  ui_banner "images • ${txReset}${list_count}"
  echo

  for img in "${list[@]}"
  do
    ui_list_item_number $i "$img"
    ((i++))
  done
  echo
}

