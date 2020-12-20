#!/usr/bin/env bash

function folder_list_get() {
  find . \
    -type f -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif"  \
     | sort | sed 's|\./||'
}

function folder_list() {
  list=( $(folder_list_get) )
  list_count=${#list[@]}

  i=1

  ui_banner "FOLDER • ${txReset}${list_count}"
  echo

  for img in ${list[@]}
  do
    ui_list_item_number $i "$img"
    ((i++))
  done
  echo
}

