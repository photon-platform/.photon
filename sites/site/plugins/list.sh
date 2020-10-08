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
    export yaml=$(cat $plugin)
    eval "$(yaml_parse plugin)" 2> /dev/null

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$(remove_quotes "$plugin_name") - $plugin_version"
    # ui_list_item "$(dirname "$plugin")"
    ((i++))
  done
  echo
}

