#!/usr/bin/env bash
function plugins_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort
}

function plugins_list() {

  list=( $(plugins_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "plugins:"

  for plugin in ${list[@]}
  do
    # gsss

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$plugin"
    ((i++))
  done
  echo
}

