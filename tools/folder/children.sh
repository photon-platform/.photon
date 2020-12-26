#!/usr/bin/env bash

function folder_children_dirs() {
  find "$PWD" -maxdepth 1 -mindepth 1 -type d ! -name ".git" | sort 
}


function folder_children() {
  # children=( $(folder_children_dirs) )
  mapfile -t children < <( folder_children_dirs )
  children_count=${#children[@]}

  ui_banner "children $SEP $children_count"
  echo

  i=1

  for child in "${children[@]}"
  do
    # ui_list_item_number $i "${child#$PWD/} $SEP $(du -s $child | awk '{ print $1}' "
    ui_list_item_number $i "$( basename "${child}" ) $SEP ${fgg12}$( folder_total_bytes "$child" )${txReset} $SEP ${fgRed}$(cd "$child"; gsss)${txReset}"

    ((i++))
  done
  echo
}

function folder_child_get() {
  id=$1
  dir=${children[$id]}
  if [[ -d "$dir" ]]
  then
    cd "$dir"
  fi
  folder
}

# TODO: rework folder renumber from page as common function
function folder_children_renumber() {
  ui_header "renumber children:"

  i=1
  dirs=()

  children=( $(folder_children_dirs) )
  children_count=${#children[@]}

  for child in ${children[@]}; do
    dir=$(dirname "$f")
    dirs+=( $dir )

    dname=$(basename -- "$dir")
    name="${dname#*.}"
    num="${dname%%.*}"

    if [[ "$num" =~ ^[0-9]+$ ]]; then
      printf -v newnum "%02d" $i
      ui_list_item_number $i "$newnum $name"
      ui_list_item  "$dname"
    else
      echo "not a numbered folder"
    fi
    ((i++))
  done
  echo

  ask=$(ask_truefalse "continue")
  echo
  if [[ $ask == "true" ]]; then
    for (( i = $(( ${#children[@]}-1 )); i>= 0; i-- )); do
      f=${children[$i]}
      dir=$(dirname "$f")
      dname=$(basename -- "$dir")
      name="${dname#*.}"
      num="${dname%%.*}"
      if [[ "$num" =~ ^[0-9]+$ ]]; then
        printf -v newnum "%02d" $(( i + 1 ))
        newdname="$newnum.$name"
        ui_list_item_number $i "$newdname"
        ui_list_item  "$dname"
        if [[ "$dname" != "$newdname" ]]; then
          mv -n "$dname" "$newdname"
        fi
      else
        echo "not a numbered folder"
      fi
    done
    ask=$(ask_truefalse "any key continue")
    echo
  fi
}
