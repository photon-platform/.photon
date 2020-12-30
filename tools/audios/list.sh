#!/usr/bin/env bash

function audios_list_get() {
  find . \
    -type f \
    -iname "*.mp3" -o \
    -iname "*.m4a" -o \
    -iname "*.opus" -o \
    -iname "*.wav"  \
     | sort | sed 's|\./||'
}

function audios_list() {
  mapfile -t list < <( audios_list_get )
  list_count=${#list[@]}

  i=1

  ui_banner "audios • ${txReset}${list_count}"
  echo

  for img in "${list[@]}"
  do
    ui_list_item_number $i "$img"
    ((i++))
  done
  echo
}

