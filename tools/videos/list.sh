#!/usr/bin/env bash

function videos_list_get() {
  find . \
    -type f \
    -iname "*.mkv" -o \
    -iname "*.mp4" -o \
    -iname "*.mov" -o \
    -iname "*.avi"  \
     | sort | sed 's|\./||'
}

function videos_list() {
  mapfile -t list < <( videos_list_get )
  list_count=${#list[@]}

  i=1

  ui_banner "videos • ${txReset}${list_count}"
  echo

  for img in "${list[@]}"
  do
    ui_list_item_number $i "$img"
    ((i++))
  done
  echo
}

