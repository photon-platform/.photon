#!/usr/bin/env bash
function themes_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function themes_list() {

  list=( $(themes_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "themes:"

  for theme in ${list[@]}
  do
    # gsss

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$theme"
    ((i++))
  done
  echo
}

